set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
cp "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/60-slotfix-nomodal.png" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-image.png"
# type text first, then attach
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs call Input.insertText '{"text":"贴图前文字 ABC 123"}' </dev/null
sleep 1
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/80-before-attach.png" </dev/null
node cdp.mjs eval "JSON.stringify({files: document.querySelectorAll('input[type=file]').length})" </dev/null
node "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/attach.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-image.png" </dev/null
sleep 3
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/81-after-attach.png" </dev/null
node cdp.mjs eval "(() => { const card = document.querySelector('[data-composer-card=\"true\"]'); const scroll = document.querySelector('[data-input-scroll]'); const cs = scroll ? getComputedStyle(scroll) : null; return JSON.stringify({ attached: card ? card.getAttribute('data-dsh-fairy-composer-attachments-active') : null, inputText: (document.querySelector('[data-composer-input]')?.textContent || '').slice(0, 40), scrollStyle: cs ? { color: cs.color, bg: cs.backgroundColor, overflow: cs.overflow, rect: scroll.getBoundingClientRect().toJSON(), z: cs.zIndex, pos: cs.position } : null, materialZ: (() => { const m = document.querySelector('[data-dsh-fairy-composer-material=\"true\"]'); return m ? m.getBoundingClientRect().toJSON() : null; })() }); })()" </dev/null