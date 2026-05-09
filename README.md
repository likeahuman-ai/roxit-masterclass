# roxit-masterclass

Docker sandbox for the Roxit AI Experience Week (2026-05-18 → 2026-05-22).
Goal: one-click → Claude Code in a contained, IT-approvable environment.

## Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 \
  -t ghcr.io/likeahuman-ai/roxit-masterclass:latest \
  -t ghcr.io/likeahuman-ai/roxit-masterclass:0.1 \
  --push .
```

Local single-arch:
```bash
docker build -t roxit-masterclass:latest .
```

## Distribute

- `Roxit-Mac.zip` → contains `Roxit.command`
- `Roxit-Windows.zip` → contains `Roxit.bat`
- Optional offline: `docker save roxit-masterclass:latest -o roxit-image.tar` and ship via USB.

## Participant flow

1. Download zip → unzip → double-click `Roxit`.
2. First time: Docker pulls the image (~500MB).
3. First time: `claude` → browser opens → approve → paste code.
4. Work in `/workspace` (= `~/roxit-workshop` on host).
