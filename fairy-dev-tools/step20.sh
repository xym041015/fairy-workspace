set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot4.log" | tail -1)
node cdp.mjs goto "$URL" </dev/null
sleep 6
echo "--- state: HDD? ---"
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe6.js" </dev/null
node cdp.mjs crop 1090 400 300 240 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/32-crop-hdd-nomodal.png" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/opensettings.js" </dev/null
sleep 3
echo "--- state: settings open ---"
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe6.js" </dev/null
node cdp.mjs crop 1090 400 300 240 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/33-crop-hdd-settings.png" </dev/null
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/34-hdd-settings-full.png" </dev/null
node "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pixel2.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/34-hdd-settings-full.png" </dev/null