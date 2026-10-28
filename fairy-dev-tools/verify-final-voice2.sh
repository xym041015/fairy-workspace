set -e
echo "=== 1) Fairy 本音（你的实例，短句）==="
curl -s -m 300 -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v1.pcm" -D "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v1.hdr" -w "http=%{http_code} ttfb=%{time_starttransfer}s total=%{time_total}s bytes=%{size_download}\n" -X POST -H "Content-Type: application/json" -d '{"text":"分析完毕，主人。"}' http://127.0.0.1:3080/fairy-voice/tts
grep -i "x-fairy-voice" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v1.hdr" || true
node -e "const b=require('fs').readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v1.pcm');let p=0,n=0;for(let i=0;i+1<b.length;i+=2){p=Math.max(p,Math.abs(b.readInt16LE(i)/32768));n++;}console.log(JSON.stringify({seconds:+(n/32000).toFixed(2),peak:+p.toFixed(3)}));"
echo "=== 2) 引擎不可用时不静音（零字节→系统语音兜底）==="
REF=$(ls ~/.dsh/fairy-voice/runtime/reference/fairy_ref.wav)
mv "$REF" "$REF.bak"
curl -s -m 300 -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v2.pcm" -D "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v2.hdr" -w "http=%{http_code} total=%{time_total}s bytes=%{size_download}\n" -X POST -H "Content-Type: application/json" -d '{"text":"兜底测试。"}' http://127.0.0.1:3080/fairy-voice/tts
grep -i "x-fairy-voice" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v2.hdr" || true
mv "$REF.bak" "$REF"
node -e "const b=require('fs').readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/v2.pcm');let p=0,n=0;for(let i=0;i+1<b.length;i+=2){p=Math.max(p,Math.abs(b.readInt16LE(i)/32768));n++;}console.log(JSON.stringify({seconds:+(n/32000).toFixed(2),peak:+p.toFixed(3)}));"
echo "=== 恢复状态 ==="
curl -s -m 10 http://127.0.0.1:3080/fairy-voice/status; echo