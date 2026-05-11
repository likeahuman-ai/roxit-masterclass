# Deploy & build pipeline

For maintainers shipping new versions of the Roxit Masterclass sandbox.

## Distribution model

- **Source repo** (this one): `likeahuman-ai/roxit-masterclass` — **private**.
- **Container image**: `ghcr.io/likeahuman-ai/roxit-masterclass:0.3` — **public** (read), multi-arch manifest (linux/arm64 + linux/amd64). Pulled by VS Code Dev Containers.
- **Public mirror repo**: [`likeahuman-ai/roxit-releases`](https://github.com/likeahuman-ai/roxit-releases) — **public**. Hosts the `.tar.gz` tarballs and `roxit-masterclass.zip` (launcher pack) so participant launchers can fetch unauthenticated.

Source stays private; only compiled artefacts go public.

## Build pipeline

### 1. Refresh plugin snapshot

```bash
./prepare-plugins.sh
```

Syncs `~/.claude/plugins/cache/` into `plugins-snapshot/` (the Docker build context). Adjust plugin paths/versions in the script when bumping.

Prereq: required plugins must be installed on the host. Bootstrap commands are at the top of `prepare-plugins.sh`.

### 2. Build images

```bash
# Multi-arch build + push to GHCR (anonymous-pullable)
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/likeahuman-ai/roxit-masterclass:0.3 --push .

# Local single-arch (for testing on Apple Silicon)
docker buildx build --platform linux/arm64 -t roxit-masterclass:0.3-arm64 --load .
```

### 3. Save tarballs for the launcher fallback flow

```bash
docker save roxit-masterclass:0.3-amd64 | gzip > roxit-masterclass-amd64.tar.gz
docker save roxit-masterclass:0.3-arm64 | gzip > roxit-masterclass-arm64.tar.gz
```

### 4. Build participant zip

```bash
mkdir -p /tmp/roxit-masterclass
cp -r starter/. /tmp/roxit-masterclass/
cp Roxit.command Roxit.bat Roxit.sh /tmp/roxit-masterclass/
chmod +x /tmp/roxit-masterclass/Roxit.{command,sh}
( cd /tmp && zip -r roxit-masterclass.zip roxit-masterclass/ )
```

The zip bundles the starter content (`.devcontainer/`, `.claude/`, `CLAUDE.md`, `index.html`, etc.) so VS Code participants see real files immediately on unzip.

### 5. Publish to the public mirror

```bash
# First-time release
gh release create v0.3 \
  --repo likeahuman-ai/roxit-releases \
  --title "v0.3 — Roxit Masterclass Sandbox" \
  --notes-file release-notes.md \
  roxit-masterclass-amd64.tar.gz \
  roxit-masterclass-arm64.tar.gz \
  /tmp/roxit-masterclass.zip

# Update existing release
gh release upload v0.3 --repo likeahuman-ai/roxit-releases --clobber \
  roxit-masterclass-amd64.tar.gz \
  roxit-masterclass-arm64.tar.gz \
  /tmp/roxit-masterclass.zip
```

## GHCR auth

First-time push needs `write:packages` scope:

```bash
gh auth refresh -h github.com -s write:packages,read:packages
echo "$(gh auth token)" | docker login ghcr.io -u <your-gh-handle> --password-stdin
```

Then make the package public via the web UI (one-time, sticky):

```
https://github.com/orgs/likeahuman-ai/packages/container/roxit-masterclass/settings
→ Danger Zone → Change visibility → Public
```

## Version bump policy

- **Rolling on v0.3** during iteration / pre-workshop testing — overwrite with `--clobber`.
- **Bump to v0.X+1** the moment the participant dry-run pack goes out. Lock the baseline, communicate the new URL, treat older versions as deprecated.
