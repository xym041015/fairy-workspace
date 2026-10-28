set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
ffmpeg -v error -y -ss 24.5 -t 8 -i fairy_raw.wav -ac 1 -ar 32000 -af "loudnorm=I=-18:TP=-2" fairy_ref8.wav
ffprobe -v error -show_entries format=duration -of default=nw=1 fairy_ref8.wav
python3 - <<'PY'
import base64, json, pathlib, urllib.request
T = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools")
audio = (T / "tts/fairy_ref8.wav").read_bytes()
text = (T / "tts/fairy_ref_candidate.txt").read_text()[:200]
payload = json.dumps({ "audioBase64": base64.b64encode(audio).decode(), "text": text }).encode()
req = urllib.request.Request("http://127.0.0.1:5599/fairy-voice/reference", data=payload, headers={"Content-Type": "application/json"})
print("install:", urllib.request.urlopen(req, timeout=60).read().decode()[:120])
PY
echo "=== 再次合成（8s 参考）==="
time curl -s -m 300 -X POST -H "Content-Type: application/json" -d '{"text":"分析：链路已经打通，主人。"}' http://127.0.0.1:5599/fairy-voice/tts -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out2.pcm" -w "http=%{http_code} bytes=%{size_download}\n"
node -e "
const fs=require('fs');const b=fs.readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out2.pcm');let peak=0,sum=0,n=0;for(let i=0;i+1<b.length;i+=2){const v=b.readInt16LE(i)/32768;peak=Math.max(peak,Math.abs(v));sum+=v*v;n++;}
console.log(JSON.stringify({bytes:b.length,seconds:+(n/32000).toFixed(2),peak:+peak.toFixed(3),silent:peak<0.01}));"