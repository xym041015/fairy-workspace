set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs goto "file:///Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/zoom.html" </dev/null
sleep 3
node cdp.mjs viewport 1040 1020 </dev/null
sleep 1
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/50-zoom-user-annotated.png" </dev/null