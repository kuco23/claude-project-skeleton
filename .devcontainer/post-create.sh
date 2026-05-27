#!/usr/bin/env bash
# Runs inside the container after creation. Installs Claude Code, and syncs
# Python deps when a pyproject.toml is present (the skeleton may not have
# one yet — guard so the command stays valid in both states).
set -euo pipefail

npm install -g @anthropic-ai/claude-code

if [ -f pyproject.toml ]; then
    uv sync
fi
