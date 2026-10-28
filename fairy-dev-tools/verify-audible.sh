set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发" </dev/null
PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true)
[ -n "$PID" ] && kill "$PID" && sleep 2 || true
(DSH_HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/home" nohup dsh --profile web --no-open --port 5599 > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" 2>&1 &)
sleep 22
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/scenario3.sh" < /dev/null | tail -1
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-audio.js" </dev/null
node cdp.mjs eval "localStorage.setItem('dsh.fairyVoice.volume','0'); JSON.stringify({volumeSet: localStorage.getItem('dsh.fairyVoice.volume')})" </dev/null
POS=$(node cdp.mjs eval "(() => { const b = document.querySelector('[data-dsh-fairy-play-control]'); const r = b.getBoundingClientRect(); return JSON.stringify({ x: Math.round(r.x + r.width/2), y: Math.round(r.y + r.height/2) }); })()" </dev/null | tail -1)
X=$(echo "$POS" | python3 -c "import sys,json; print(json.load(sys.stdin)['x'])")
Y=$(echo "$POS" | python3 -c "import sys,json; print(json.load(sys.stdin)['y'])")
echo "clicking play control at $X,$Y (volume 0 -> guard should raise it)"
node cdp.mjs call Input.dispatchMouseEvent "{\"type\":\"mousePressed\",\"x\":$X,\"y\":$Y,\"button\":\"left\",\"buttons\":1,\"clickCount\":1}" </dev/null
node cdp.mjs call Input.dispatchMouseEvent "{\"type\":\"mouseReleased\",\"x\":$X,\"y\":$Y,\"button\":\"left\",\"buttons\":0,\"clickCount\":1}" </dev/null
sleep 3
node cdp.mjs evalfile "'"/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools"'/dispatch-play.js" </dev/null 2>/dev/null || true
node cdp.mjs eval "(() => { window.dispatchEvent(new CustomEvent('fairy-voice-play', { detail: { messageId: 'probe-final-2', markdown: '这是一次语音播放探针，用来确认朗读链路是否出声。', sessionKey: 'session-9b5e6fd5-a2fb-45f1-994c-cf83498133d8' } })); return 'dispatched'; })()" </dev/null
sleep 12
node cdp.mjs eval "JSON.stringify(window.__fairyAudioReport ? window.__fairyAudioReport() : { error: 'not hooked' })" </dev/null