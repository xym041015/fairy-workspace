set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
echo "=== 通过插件 /fairy-voice/tts 合成（GPT-SoVITS CPU，稍慢）==="
time curl -s -m 180 -X POST -H "Content-Type: application/json" -d '{"text":"分析：链路已经打通，主人。"}' http://127.0.0.1:5599/fairy-voice/tts -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out.pcm" -w "http=%{http_code} bytes=%{size_download}\n"
node pcm-stats.mjs "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out.pcm" 2>/dev/null || node -e "
const fs=require('fs');const b=fs.readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out.pcm');let peak=0,sum=0,n=0;for(let i=0;i+1<b.length;i+=2){const v=b.readInt16LE(i)/32768;peak=Math.max(peak,Math.abs(v));sum+=v*v;n++;}
console.log(JSON.stringify({bytes:b.length,samples:n,seconds:+(n/32000).toFixed(2),peak:+peak.toFixed(3),silent:peak<0.01}));"
echo "=== 镜像日志：是否走了兜底 ==="
grep -c "tts.stream.fallback" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" || echo "0 (说明用的是 GPT-SoVITS ✓)"