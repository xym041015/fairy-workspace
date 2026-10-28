set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hide-skin.js" </dev/null
sleep 1
node cdp.mjs crop 1240 800 272 145 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/92-rightcol-clean.png" </dev/null
node cdp.mjs crop 270 790 1242 155 1 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/93-dock-clean.png" </dev/null