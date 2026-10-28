set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL="http://127.0.0.1:5599/?token=qPNh4xYyboU23iKLv3Ul8WlH-azAtT1442lkndvkgz8"
node cdp.mjs goto "$URL" </dev/null
sleep 4
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/01-hero.png" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe.js" </dev/null