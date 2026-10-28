set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs crop 440 790 900 160 1 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/101-native-dock-band.png" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({modal: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'), cardVis: getComputedStyle(document.querySelector('[data-composer-card=\"true\"]')).visibility, slotVis: (() => { const s = document.querySelector('[data-slot=\"conversation.composer\"]'); return s ? getComputedStyle(s).visibility : null; })()})" </dev/null
node cdp.mjs crop 440 780 900 170 1 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/102-native-modal.png" </dev/null