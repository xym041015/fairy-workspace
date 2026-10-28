set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs call Input.insertText '{"text":"贴图后文字应可见 XYZ"}' </dev/null
sleep 1
node"" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/attach.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-image.png" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-holevars.js" </dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print('after:', d['after']['zIndex'], d['after']['left'], d['after']['top'], d['after']['width'], d['after']['height'], d['after']['background'])"
node cdp.mjs eval "JSON.stringify({scrollZ: getComputedStyle(document.querySelector('[data-input-scroll]')).zIndex, attached: document.querySelector('[data-composer-card=\"true\"]').getAttribute('data-dsh-fairy-composer-attachments-active')})" </dev/null
node cdp.mjs crop 440 805 800 55 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/90-inputline-after-fix.png" </dev/null
node cdp.mjs crop 1180 810 332 135 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/91-rightcolumn-after-fix.png" </dev/null