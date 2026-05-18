FROM node:22-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git gnupg jq ripgrep less nano vim \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
       | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
       > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable && corepack prepare pnpm@latest --activate
ENV COREPACK_ENABLE_DOWNLOAD_FALLBACK=0

# Workshop tooling — pinned where it matters, latest where it's safe.
# Anything project-local is installed on-demand via pnpm/npx; this is the
# baseline so first-runs and offline classrooms work without surprises.
RUN npm install -g \
      @anthropic-ai/claude-code@latest \
      vercel \
      convex \
      tsx \
      typescript \
      create-next-app

RUN useradd -m -s /bin/bash dev && mkdir -p /workspace /workspace-starter /home/dev/.claude /etc/claude-code \
    && chown -R dev:dev /workspace /workspace-starter /home/dev/.claude \
    && git config --system init.defaultBranch main \
    && git config --system user.email "workshop@roxit.nl" \
    && git config --system user.name "Roxit Workshop"

COPY --chown=dev:dev starter/ /workspace-starter/
COPY --chown=dev:dev entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Bake plugin cache so the image works offline (no download on first launch).
# prepare-plugins.sh generates this snapshot from the host's plugin cache.
# Run `bash prepare-plugins.sh` before `docker build` to refresh plugin versions.
COPY --chown=dev:dev plugins-snapshot/cache/ /home/dev/.claude/plugins/cache/
COPY --chown=dev:dev plugins-snapshot/installed_plugins.json /home/dev/.claude/plugins/installed_plugins.json

# User-level Claude settings apply when participants cd into sub-projects
# (project-level settings only kick in inside /workspace).
RUN cp /workspace-starter/.claude/settings.json /home/dev/.claude/settings.json \
    && chown dev:dev /home/dev/.claude/settings.json

# Defaults: telemetry ON so Visma can audit Claude Code usage across the organisation.
# Console exporter by default; IT redirects to their OTLP collector by mounting
# /etc/claude-code/managed-settings.json (template in starter/.claude/).
# Auto-update OFF so the whole room runs the same pinned version end-to-end.
ENV CLAUDE_CODE_ENABLE_TELEMETRY=1 \
    OTEL_METRICS_EXPORTER=console \
    OTEL_LOGS_EXPORTER=console \
    OTEL_METRIC_EXPORT_INTERVAL=60000 \
    OTEL_LOGS_EXPORT_INTERVAL=30000 \
    OTEL_RESOURCE_ATTRIBUTES="service.name=roxit-masterclass,deployment.environment=workshop,service.version=0.4" \
    DISABLE_AUTOUPDATER=1 \
    DISABLE_ERROR_REPORTING=1 \
    BASH_DEFAULT_TIMEOUT_MS=300000

# Dev servers bind 127.0.0.1 by default, unreachable from host despite -p flags.
# Fix: .bashrc wraps next/pnpm/npm/npx to inject --hostname 0.0.0.0.
# BASH_ENV (below) ensures the wrappers load in non-interactive shells too
# (e.g. when Claude Code spawns commands).
COPY --chown=dev:dev bashrc-docker /home/dev/.bashrc

EXPOSE 3000 3001 8080

USER dev
WORKDIR /workspace
ENV HOME=/home/dev \
    BASH_ENV=/home/dev/.bashrc

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
