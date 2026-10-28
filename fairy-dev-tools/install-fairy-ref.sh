set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
cp ref_a.wav fairy_ref.wav && cp ref_a.txt fairy_ref.txt
python3 - <<'PY'
import base64, json, pathlib, urllib.request
T = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools")
audio = (T / "tts/fairy_ref.wav").read_bytes()
text = (T / "tts/fairy_ref.txt").read_text().strip()
payload = json.dumps({"audioBase64": base64.b64encode(audio).decode(), "text": text}).encode()
req = urllib.request.Request("http://127.0.0.1:3080/fairy-voice/reference", data=payload, headers={"Content-Type": "application/json"})
print("install ->", urllib.request.urlopen(req, timeout=90).read().decode()[:160])
PY
echo "=== 你的实例 status ==="
curl -s -m 10 http://127.0.0.1:3080/fairy-voice/status; echo
echo "=== 用 Fairy 本音合成一句（真机）==="
time curl -s -m 300 -X POST -H "Content-Type: application/json" -d '{"text":"分析完毕，主人。今天也请多指教。"}' http://127.0.0.1:3080/fairy-voice/tts -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/fairy-voice-test.pcm" -w "http=%{http_code} bytes=%{size_download}\n"
node -e "
const fs=require('fs');const b=fs.readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/fairy-voice-test.pcm');let peak=0,sum=0,n=0;for(let i=0;i+1<b.length;i+=2){const v=b.readInt16LE(i)/32768;peak=Math.max(peak,Math.abs(v));sum+=v*v;n++;}
console.log(JSON.stringify({bytes:b.length,seconds:+(n/32000).toFixed(2),peak:+peak.toFixed(3),silent:peak<0.01}));"
ffmpeg -v error -y -f s16le -ar 32000 -ac 1 -i "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/fairy-voice-test.pcm" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/fairy-voice-test.wav" && echo "已导出试听文件: /Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/fairy-voice-test.wav"