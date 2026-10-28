set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({modal: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'), dock: getComputedStyle(document.querySelector('[data-dsh-fairy-composer-dock=\"true\"]')).visibility})" </dev/null
node cdp.mjs crop 270 800 1242 145 1 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/65-dock-full.png" </dev/null
node cdp.mjs crop 1180 800 332 145 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/66-dock-farright.png" </dev/null
node cdp.mjs crop 280 800 500 145 2 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/67-dock-left.png" </dev/null