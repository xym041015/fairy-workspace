set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot2.log" | tail -1)
node cdp.mjs goto "$URL" </dev/null
sleep 6
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs eval "JSON.stringify({tree:[...document.querySelectorAll('[role=\"treeitem\"]')].map(t=>(t.textContent||'').trim().slice(0,24)), wsTree: document.querySelectorAll('[role=\"tree\"]').length})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/11-workspace.png" </dev/null