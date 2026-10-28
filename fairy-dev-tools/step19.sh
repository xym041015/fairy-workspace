set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs crop 1090 400 300 240 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/30-crop-settings-open.png" </dev/null
node cdp.mjs eval "(() => { const b=[...document.querySelectorAll('[role=\"dialog\"]')].pop()?.querySelector('button[aria-label],button'); return 'ok'; })()" </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
sleep 2
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe6.js" </dev/null
node cdp.mjs crop 1090 400 300 240 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/31-crop-no-modal.png" </dev/null