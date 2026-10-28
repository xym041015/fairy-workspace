set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs call Input.insertText '{"text":"布局探针 layout probe"}' </dev/null
sleep 1
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13,"text":"\r"}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
sleep 10
node cdp.mjs eval "JSON.stringify({phases:[...document.querySelectorAll('[data-phase]')].map(n=>n.getAttribute('data-phase')), conv: !!document.querySelector('[data-slot=\"main.conversation\"] [data-phase=\"active\"]'), docks: document.querySelectorAll('[data-dsh-fairy-composer-dock]').length, modalFlag: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'), tree:[...document.querySelectorAll('[role=\"treeitem\"]')].map(t=>(t.textContent||'').trim().slice(0,20))})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/12-active.png" </dev/null