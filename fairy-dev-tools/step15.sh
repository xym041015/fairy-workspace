set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe2.js" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/13-hdd-settings.png" </dev/null
echo "=== pixel regions (HDD ON + settings open) ==="
node "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pixel.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/13-hdd-settings.png" </dev/null