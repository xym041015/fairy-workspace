set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1)
node cdp.mjs viewport 1512 945 </dev/null
node cdp.mjs goto "$URL" </dev/null
sleep 6
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/keyset2.js" </dev/null || true
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs call Input.insertText '{"text":"dock 布局排查 probe"}' </dev/null
sleep 1
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
sleep 9
node cdp.mjs eval "JSON.stringify({phase:[...document.querySelectorAll('[data-phase]')].map(n=>n.getAttribute('data-phase')), dock: !!document.querySelector('[data-dsh-fairy-composer-dock=\"true\"]'), appHeight: getComputedStyle(document.documentElement).getPropertyValue('--dsh-composer-height')})" </dev/null