set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1)
node cdp.mjs goto "$URL" </dev/null
sleep 6
# onboarding: dismiss or set a dummy key
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/keyset2.js" </dev/null || true
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/dismiss.js" </dev/null || true
sleep 2
# start a session
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs call Input.insertText '{"text":"遮挡排查 probe"}' </dev/null
sleep 1
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
sleep 9
node cdp.mjs eval "JSON.stringify({phase:[...document.querySelectorAll('[data-phase]')].map(n=>n.getAttribute('data-phase')), visual: document.documentElement.hasAttribute('data-dsh-fairy-visual'), mode: document.documentElement.getAttribute('data-dsh-fairy-mode')})" </dev/null
# open settings
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe9.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/40-scenario-settings.png" </dev/null