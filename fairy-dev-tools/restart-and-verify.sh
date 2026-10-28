set -e
echo "=== 当前 9880 状态 ==="; lsof -ti tcp:9880 -sTCP:LISTEN 2>/dev/null | head -3 || echo "无监听"
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/stop-voice-engine.sh" >/dev/null 2>&1 || true
for i in $(seq 1 20); do lsof -ti tcp:9880 -sTCP:LISTEN >/dev/null 2>&1 || break; sleep 1; done
echo "=== 干净启动 ==="
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/start-voice-engine.sh" 2>&1 | tail -1
sleep 5
echo "=== Fairy 本音合成（首次会加载模型，可能 10-30 秒）==="
curl -s -m 300 -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v3.pcm" -D "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v3.hdr" -w "http=%{http_code} ttfb=%{time_starttransfer}s total=%{time_total}s bytes=%{size_download}\n" -X POST -H "Content-Type: application/json" -d '{"text":"分析完毕，主人。"}' http://127.0.0.1:3080/fairy-voice/tts
grep -i "x-fairy-voice" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v3.hdr" || true
node -e "const b=require('fs').readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v3.pcm');let p=0,n=0;for(let i=0;i+1<b.length;i+=2){p=Math.max(p,Math.abs(b.readInt16LE(i)/32768));n++;}console.log(JSON.stringify({bytes:b.length,seconds:+(n/32000).toFixed(2),peak:+p.toFixed(3),silent:p<0.01}));"
ffmpeg -v error -y -f s16le -ar 32000 -ac 1 -i "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v3.pcm" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/fairy-voice-final.wav" 2>/dev/null && echo "试听: fairy-dev-tools/fairy-voice-final.wav"