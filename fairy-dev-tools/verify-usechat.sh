set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-usechat.py"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/client.js && echo SYNTAX_OK
for i in 1 2 3; do PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true); [ -n "$PID" ] && kill "$PID" && sleep 1 || break; done
sleep 2
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/make-mirror.sh" < /dev/null | tail -1
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/browser.sh" < /dev/null | head -2
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/scenario3.sh" < /dev/null | tail -1
sleep 5
echo "=== timeline probe after the fix ==="
node cdp.mjs eval "JSON.stringify(window.__fairyProbe || { missing: true }, null, 1)" </dev/null
echo "=== hooks probe ==="
node cdp.mjs eval "JSON.stringify((window.__fairyHooks || []).map((h) => ({ name: h.name, keys: h.keys })), null, 1)" </dev/null