set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发" </dev/null
PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true)
[ -n "$PID" ] && kill "$PID" && sleep 2 || true
(DSH_HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/home" nohup dsh --profile web --no-open --port 5599 > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot4.log" 2>&1 &)
sleep 22
grep -o "dsh web: http://127.0.0.1:[0-9]*/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot4.log" | tail -1