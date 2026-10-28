set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({dialogs: document.querySelectorAll('[role=\"dialog\"]').length, modalFlag: document.documentElement.hasAttribute('data-dsh-fairy-modal-open')})" </dev/null
echo "=== synthetic generic-modal probe ==="
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/synthetic-modal.js" </dev/null