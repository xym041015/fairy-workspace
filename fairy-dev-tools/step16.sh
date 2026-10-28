set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/closeesc.js" </dev/null
sleep 2
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hddtoggle.js" </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({visual: document.documentElement.hasAttribute('data-dsh-fairy-visual'), mode: document.documentElement.getAttribute('data-dsh-fairy-mode')})" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe2.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/14-nohdd-settings.png" </dev/null
echo "=== pixel regions (HDD OFF + settings open) ==="
node "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pixel.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/14-nohdd-settings.png" </dev/null