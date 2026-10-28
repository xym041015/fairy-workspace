set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe11.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/70-modal-with-dock.png" </dev/null
node "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pixel2.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/70-modal-with-dock.png" </dev/null