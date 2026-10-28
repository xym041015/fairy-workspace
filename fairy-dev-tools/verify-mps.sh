set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-mps.py"
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/stop-voice-engine.sh" >/dev/null 2>&1 || true; sleep 3
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/start-voice-engine.sh" 2>&1 | tail -1
echo "=== 首包/总时延（MPS）==="
time curl -s -m 300 -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mps-test.pcm" -w "http=%{http_code} ttfb=%{time_starttransfer}s total=%{time_total}s bytes=%{size_download}\n" -X POST -H "Content-Type: application/json" -d '{"text":"分析完毕，主人。今天的进度我一直在盯着。"}' http://127.0.0.1:3080/fairy-voice/tts
node -e "
const fs=require('fs');const b=fs.readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mps-test.pcm');let peak=0,n=0;for(let i=0;i+1<b.length;i+=2){const v=b.readInt16LE(i)/32768;peak=Math.max(peak,Math.abs(v));n++;}
console.log(JSON.stringify({bytes:b.length,seconds:+(n/32000).toFixed(2),peak:+peak.toFixed(3),silent:peak<0.01}));"
grep -vE "^  File|^    " "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log" | tail -3