set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-status-backend.py"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/index.js && npm test 2>&1 | grep -E "ℹ (pass|fail)" | head -3
for i in 1 2 3; do PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true); [ -n "$PID" ] && kill "$PID" && sleep 1 || break; done
sleep 1
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/make-mirror.sh" < /dev/null | tail -1