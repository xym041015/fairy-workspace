set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/newsession.js" </dev/null
sleep 4
node cdp.mjs eval "JSON.stringify({phase:[...document.querySelectorAll('[data-phase]')].map(n=>n.getAttribute('data-phase')), conv: !!document.querySelector('[data-slot=\"conversation\"]'), ta: !!document.querySelector('textarea'), docks: document.querySelectorAll('[data-dsh-fairy-composer-dock]').length, slots:[...new Set([...document.querySelectorAll('[data-slot]')].map(n=>n.getAttribute('data-slot')))].slice(0,40)})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/05-newsession.png" </dev/null