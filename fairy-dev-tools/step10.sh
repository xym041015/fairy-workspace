set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/keyset2.js" </dev/null
sleep 5
node cdp.mjs eval "JSON.stringify({dialogs:[...document.querySelectorAll('[role=\"dialog\"]')].map(d=>d.getAttribute('aria-label')), input: (()=>{const i=document.querySelector('[data-composer-input]');return i?{ce:i.getAttribute('contenteditable'),ph:i.getAttribute('data-placeholder')}:null})(), modalFlag: document.documentElement.hasAttribute('data-dsh-fairy-modal-open')})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/08-key.png" </dev/null