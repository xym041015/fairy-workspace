#!/usr/bin/env bash
# 无头 Edge + CDP（沙箱内需要 --no-sandbox）
set -euo pipefail
T="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools"
mkdir -p "$T/cache" "$T/crash"
pkill -f "fairy-dev-tools/edge-profile" 2>/dev/null || true
sleep 1
(nohup "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" --headless=new --no-sandbox --disable-gpu \
  --disable-breakpad --disable-crash-reporter --no-first-run --no-default-browser-check \
  --disk-cache-dir="$T/cache" --crash-dumps-dir="$T/crash" \
  --remote-debugging-port=9334 --user-data-dir="$T/edge-profile2" about:blank > "$T/edge.log" 2>&1 &)
sleep 6
curl -s -m 3 http://127.0.0.1:9334/json/version | head -3