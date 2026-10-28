set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs goto "http://127.0.0.1:5599/?token=qPNh4xYyboU23iKLv3Ul8WlH-azAtT1442lkndvkgz8" </dev/null
sleep 4
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pickws.js" </dev/null
sleep 2
node cdp.mjs eval "JSON.stringify({menus:[...document.querySelectorAll('[role=\"menu\"],[role=\"listbox\"]')].map(m=>[...m.querySelectorAll('[role=\"menuitem\"],[role=\"option\"]')].map(i=>(i.textContent||'').trim().slice(0,30))), input: (()=>{const i=document.querySelector('[data-composer-input]');return i?{ce:i.getAttribute('contenteditable'),ph:i.getAttribute('data-placeholder')}:null})()})" </dev/null