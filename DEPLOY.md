# Deploy & build pipeline

For maintainers shipping new versions of the Roxit Masterclass sandbox.

## Distribution model

- **Source repo** (this one): `likeahuman-ai/roxit-masterclass` — **private**.
- **Container image**: `ghcr.io/likeahuman-ai/roxit-masterclass:0.5` — **public** (read), multi-arch manifest (linux/arm64 + linux/amd64). Pulled by VS Code Dev Containers.
- **Public mirror repo**: [`likeahuman-ai/roxit-releases`](https://github.com/likeahuman-ai/roxit-releases) — **public**. Hosts the `.tar.gz` tarballs and `roxit-masterclass.zip` (launcher pack) so participant launchers can fetch unauthenticated.

Source stays private; only compiled artefacts go public.

## Self-updating launchers — read before every release

The launchers (`Roxit.command` / `Roxit.sh` / `Roxit.bat`) are **self-updating**. On
each run they query the GitHub API for the *latest* release of `roxit-releases`
(`/releases/latest`) and derive the image tag + download URL from its
`tag_name`. Consequences for releasing:

- **`--latest` is mandatory.** The GitHub "latest" marker is what the API
  returns. A release created without `--latest` (or not promoted to latest) is
  **invisible to every launcher in the field** — no one auto-updates.
- **Publish order is load-bearing.** Upload tarballs + zip **first**, then
  create/promote the release with `--latest` **last**. Reversed, every launcher
  worldwide resolves the new version, hits a 404 on the tarball, and falls back
  (recoverable but noisy — defeats the point).
- **Keep `FALLBACK_VERSION` current.** Bump the `FALLBACK_VERSION` constant in
  all three launchers every release. It is the offline / API-unreachable path;
  a stale value silently downgrades disconnected participants.
- **One-time redistribution.** Self-update is **not retroactive**. Participants
  still holding a pre-v0.5 launcher file have no `LATEST_API` logic — they must
  receive the v0.5 launcher zip **once**. After that, the launcher updates
  itself and the zip never needs redistributing again.
- Anonymous GitHub API is 60 req/hr/IP. A workshop room behind one NAT is well
  under that; the fallback path covers the rare case it isn't.

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
  -t ghcr.io/likeahuman-ai/roxit-masterclass:0.5 --push .

# Local single-arch (for testing on Apple Silicon)
docker buildx build --platform linux/arm64 -t roxit-masterclass:0.5-arm64 --load .
```

### 3. Save tarballs for the launcher fallback flow

```bash
docker save roxit-masterclass:0.5-amd64 | gzip > roxit-masterclass-amd64.tar.gz
docker save roxit-masterclass:0.5-arm64 | gzip > roxit-masterclass-arm64.tar.gz
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

### 5. Smoke-test all three launchers — GATE

Before publishing, run each launcher against the freshly built image. **The
Windows path cannot be skipped** — `Roxit.bat` has no test coverage and a
broken batch file silently kills the entire Windows cohort with no fallback.

- macOS — double-click `Roxit.command`, confirm version resolves + image loads.
- Linux — `bash Roxit.sh`, same.
- Windows — double-click `Roxit.bat` on a real Windows 10/11 box (or VM).
  Confirm the API parse yields the right tag and the container starts.

Do not proceed to step 6 until all three are green.

### 6. Publish to the public mirror — ORDER MATTERS

Artifacts **first**, release marker **last**. The launchers resolve the
GitHub "latest" release and immediately fetch its tarball; if the marker
flips before the tarballs exist, every launcher in the field 404s.

```bash
# First-time release for this version — upload assets, set --latest LAST.
gh release create v0.5 \
  --repo likeahuman-ai/roxit-releases \
  --title "v0.5 — Roxit Masterclass Sandbox" \
  --notes-file release-notes.md \
  --latest \
  roxit-masterclass-amd64.tar.gz \
  roxit-masterclass-arm64.tar.gz \
  /tmp/roxit-masterclass.zip
```

`gh release create` uploads the listed assets as part of creation, so for a
brand-new tag the single command above is already correctly ordered (assets
attach before the release is visible). **Never** create the release first and
`upload` assets after — that is the 404 window.

To replace assets on an existing v0.5 (pre-publish iteration only — never
once participants have it):

```bash
gh release upload v0.5 --repo likeahuman-ai/roxit-releases --clobber \
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

With self-updating launchers the model is simpler than before — there is no
"communicate the new URL" step, because launchers discover the latest release
themselves.

- **Pre-publish iteration:** roll on the current version, overwrite assets with
  `--clobber`. Safe only while no participant holds the launcher yet.
- **Cutting a new version:** bump the version string in `Dockerfile`,
  `SECURITY.md`, the `README` badge, and `FALLBACK_VERSION` in all three
  launchers; build; publish with `--latest` (steps above). Launchers in the
  field pick it up on their next run automatically — no re-distribution.
- **The one exception:** participants still on a *pre-self-update* launcher
  (anything shipped before v0.5) must receive the v0.5 launcher zip once. This
  is the last manual redistribution; self-update is not retroactive.
