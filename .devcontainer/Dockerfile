FROM mcr.microsoft.com/devcontainers/python:3.12

# uv binary, copied from the official distroless image.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Place the venv outside the workspace so it survives the bind-mount overlay
# at /workspaces/<project> and the interpreter is available on first attach.
ENV UV_PROJECT_ENVIRONMENT=/home/vscode/.venv

# Optional dependency pre-install. The [l]/[k] globs make COPY silently skip
# missing files, so the skeleton (no pyproject.toml yet) still builds. When
# the files DO exist, `--no-install-project` installs only the deps; the
# project itself is installed by the postCreate `uv sync` against the real
# workspace mount.
COPY pyproject.tom[l] uv.loc[k] /tmp/build/
RUN if [ -f /tmp/build/pyproject.toml ]; then \
        cd /tmp/build && uv sync --no-install-project && \
        chown -R vscode:vscode /home/vscode/.venv; \
    fi && rm -rf /tmp/build

# Pre-create the uv cache directory so the named volume mount inherits vscode
# ownership on first container start. Docker copies image content into the
# empty volume preserving permissions; on later rebuilds the volume wins, so
# Dockerfile changes to these paths only take effect after `docker volume rm`.
RUN mkdir -p /home/vscode/.cache/uv && chown -R vscode:vscode /home/vscode/.cache

# Install Playwright browsers + OS deps when playwright was pulled in by uv
# sync. `install-deps` runs as root (apt packages); `install` runs as vscode
# so the browser bundle lands under the user's home cache.
RUN if [ -x /home/vscode/.venv/bin/playwright ]; then \
        /home/vscode/.venv/bin/playwright install-deps && \
        su vscode -c "/home/vscode/.venv/bin/playwright install"; \
    fi
