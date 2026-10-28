set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-logs.js" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/click-play.js" </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({ logs: (window.__voiceLog || []).slice(-12), audio: window.__fairyAudioReport ? window.__fairyAudioReport() : null })" </dev/null