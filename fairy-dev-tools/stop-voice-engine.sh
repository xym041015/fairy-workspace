#!/usr/bin/env bash
# 停止 Fairy 本音引擎
set -euo pipefail
PIDS=$(lsof -ti tcp:9880 -sTCP:LISTEN 2>/dev/null || true)
[ -z "$PIDS" ] && { echo "not running"; exit 0; }
kill $PIDS && echo "stopped: $PIDS"