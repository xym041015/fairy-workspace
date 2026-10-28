set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/keyset.js" </dev/null
sleep 4
node cdp.mjs eval "JSON.stringify({dialogs:[...document.querySelectorAll('[role=\"dialog\"]')].map(d=>d.getAttribute('aria-label')), phase:[...document.querySelectorAll('[data-phase]')].map(n=>n.getAttribute('data-phase')), ta: !!document.querySelector('[data-composer-card=\"true\"] textarea')})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/04-keyset.png" </dev/null