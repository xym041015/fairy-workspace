set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-trace.py"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发" </dev/null
PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true)
[ -n "$PID" ] && kill "$PID" && sleep 2 || true
(DSH_HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/home" nohup dsh --profile web --no-open --port 5599 > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" 2>&1 &)
sleep 22
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/scenario3.sh" < /dev/null | tail -1
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-audio.js" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-logs.js" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/click-play.js" </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({ trace: window.__fairyTrace || [], audio: window.__fairyAudioReport(), logs: (window.__voiceLog || []).slice(-6) })" </dev/null