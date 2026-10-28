set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/addws.js" </dev/null
sleep 2
node cdp.mjs eval "JSON.stringify({dialogs:[...document.querySelectorAll('[role=\"dialog\"]')].map(d=>({label:d.getAttribute('aria-label'),text:(d.textContent||'').trim().slice(0,200)})), inputs:[...document.querySelectorAll('input')].map(i=>({type:i.type,ph:i.placeholder,label:i.getAttribute('aria-label')})).slice(0,8), menus:[...document.querySelectorAll('[role=\"menu\"],[role=\"listbox\"]')].map(m=>(m.textContent||'').trim().slice(0,120))})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/09-addws.png" </dev/null