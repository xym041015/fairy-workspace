set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/dispatch-play.js" </dev/null
sleep 12
echo "=== web audio instrumentation ==="
node cdp.mjs eval "JSON.stringify(window.__fairyAudioReport ? window.__fairyAudioReport() : { error: 'not hooked' })" </dev/null
echo "=== host log voice ops ==="
grep -o '"operation":"[a-z.]*"' "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | sort | uniq -c | tail -6