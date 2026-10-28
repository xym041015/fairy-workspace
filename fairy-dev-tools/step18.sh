set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/open2.js" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hddsection.js" </dev/null
sleep 2
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hddcheck.js" </dev/null
sleep 2
node cdp.mjs eval "JSON.stringify({visual: document.documentElement.hasAttribute('data-dsh-fairy-visual'), checks: [...document.querySelectorAll('[role=\"dialog\"] input[type=checkbox]')].map(i=>({checked:i.checked, label:(i.closest('label')?.textContent||'').trim().slice(0,18)}))})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/22-hdd-section.png" </dev/null