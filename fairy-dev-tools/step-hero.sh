set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Escape","code":"Escape","windowsVirtualKeyCode":27,"nativeVirtualKeyCode":27}' </dev/null
sleep 2
node cdp.mjs eval "(() => { const b = [...document.querySelectorAll('[data-slot=\"sidebar\"] button')].find(x => (x.getAttribute('aria-label')||'') === '新建会话'); if (b) b.click(); return 'clicked'; })()" </dev/null
sleep 4
node cdp.mjs eval "JSON.stringify({phase: [...document.querySelectorAll('[data-phase]')].map(n => n.getAttribute('data-phase')), dock: !!document.querySelector('[data-dsh-fairy-composer-dock=\"true\"]'), dockVis: (() => { const d = document.querySelector('[data-dsh-fairy-composer-dock=\"true\"]'); return d ? getComputedStyle(d).visibility : null; })(), cardRect: (() => { const c = document.querySelector('[data-composer-card=\"true\"]'); return c ? c.getBoundingClientRect().toJSON() : null; })()})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/71-hero-with-dock.png" </dev/null