set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/addws.js" </dev/null
sleep 2
node cdp.mjs eval "JSON.stringify({dialogs:[...document.querySelectorAll('[role=\"dialog\"]')].map(d=>({label:d.getAttribute('aria-label'),html:d.outerHTML.slice(0,400)})), inputs:[...document.querySelectorAll('input[type=\"text\"],input:not([type])')].map(i=>({ph:i.placeholder,label:i.getAttribute('aria-label')})).slice(0,6)})" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/07-addws.png" </dev/null