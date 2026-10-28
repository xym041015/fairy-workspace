set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-probe2.py"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/client.js && echo SYNTAX_OK
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/make-mirror.sh" < /dev/null | tail -1
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/browser.sh" < /dev/null | head -2
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/scenario3.sh" < /dev/null | tail -1
sleep 4
node cdp.mjs eval "JSON.stringify(window.__fairyProbe || { missing: true }, null, 1)" </dev/null