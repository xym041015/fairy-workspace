set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1)
node cdp.mjs viewport 1512 945 </dev/null
node cdp.mjs goto "$URL" </dev/null
sleep 6
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null || true
node cdp.mjs call Input.insertText '{"text":"槽位兼容验证 probe"}' </dev/null
sleep 1
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
sleep 9
echo "--- active session, no modal ---"
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe10.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/60-slotfix-nomodal.png" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
echo "--- settings open ---"
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe10.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/61-slotfix-settings.png" </dev/null
node "${T}/pixel2.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/61-slotfix-settings.png" </dev/null