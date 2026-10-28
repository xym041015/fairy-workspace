set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-relayout.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/95-relayout-full.png" </dev/null
node cdp.mjs crop 270 795 1242 150 1 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/96-relayout-dock.png" </dev/null
node cdp.mjs crop 1100 795 412 150 2 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/97-relayout-rail.png" </dev/null