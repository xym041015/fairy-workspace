set -e
for i in 1 2 3; do PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true); [ -n "$PID" ] && kill "$PID" && sleep 1 || break; done
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/make-mirror.sh" < /dev/null | tail -1
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/browser.sh" < /dev/null | head -2
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/scenario3.sh" < /dev/null | tail -1
echo "=== 给镜像装同一段 Fairy 参考 ==="
python3 - <<'PY'
import base64, json, pathlib, urllib.request
T = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools")
audio = (T / "tts/fairy_ref.wav").read_bytes()
text = (T / "tts/fairy_ref.txt").read_text().strip()
payload = json.dumps({"audioBase64": base64.b64encode(audio).decode(), "text": text}).encode()
req = urllib.request.Request("http://127.0.0.1:5599/fairy-voice/reference", data=payload, headers={"Content-Type": "application/json"})
print("install ->", urllib.request.urlopen(req, timeout=90).read().decode()[:120])
print("status  ->", urllib.request.urlopen("http://127.0.0.1:5599/fairy-voice/status", timeout=15).read().decode()[:160])
PY
echo "=== 浏览器端：hook + 投递播放事件 ==="
SESS=$(ls "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/home/sessions/"*/ 2>/dev/null | head -1 | xargs basename)
echo "session: $SESS"
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-audio.js" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-logs.js" </dev/null
node cdp.mjs eval "(() => { window.dispatchEvent(new CustomEvent('fairy-voice-play', { detail: { messageId: 'probe-fairy-1', markdown: '分析完毕，主人。', sessionKey: '$SESS' } })); return 'dispatched'; })()" </dev/null
sleep 20
node cdp.mjs eval "JSON.stringify({ audio: window.__fairyAudioReport(), logs: (window.__voiceLog || []).slice(-6) }, null, 1)" </dev/null
echo "=== 主机侧 voice 操作 ==="
grep -o '"operation":"[a-z.]*"' "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | sort | uniq -c | tail -6