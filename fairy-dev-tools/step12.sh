set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/realclick.js" </dev/null
sleep 2
node cdp.mjs eval "JSON.stringify({menus:[...document.querySelectorAll('[role=\"menu\"],[role=\"listbox\"],[role=\"dialog\"]')].map(m=>({role:m.getAttribute('role'),text:(m.textContent||'').trim().slice(0,160)})), items:[...document.querySelectorAll('[role=\"menuitem\"],[role=\"option\"]')].map(i=>(i.textContent||'').trim().slice(0,40))})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/10-wsmenu.png" </dev/null