set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-audio.js" </dev/null
POS=$(node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/voice-ctl-pos.js" </dev/null | tail -1)
echo "control: $POS"
X=$(echo "$POS" | python3 -c "import sys,json; print(json.load(sys.stdin)['x'])")
Y=$(echo "$POS" | python3 -c "import sys,json; print(json.load(sys.stdin)['y'])")
node cdp.mjs call Input.dispatchMouseEvent "{\"type\":\"mousePressed\",\"x\":$X,\"y\":$Y,\"button\":\"left\",\"buttons\":1,\"clickCount\":1}" </dev/null
node cdp.mjs call Input.dispatchMouseEvent "{\"type\":\"mouseReleased\",\"x\":$X,\"y\":$Y,\"button\":\"left\",\"buttons\":0,\"clickCount\":1}" </dev/null
sleep 12
node cdp.mjs eval "JSON.stringify(window.__fairyAudioReport ? window.__fairyAudioReport() : { error: 'not hooked' })" </dev/null