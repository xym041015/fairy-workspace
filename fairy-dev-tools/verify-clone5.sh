set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"; export HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/home"
uv pip install --python .venv/bin/python --index-url https://pypi.tuna.tsinghua.edu.cn/simple torchcodec 2>&1 | tail -3
.venv/bin/python -c "import torchcodec, torch, torchaudio; print('torchcodec', torchcodec.__version__, 'torch', torch.__version__, 'ta', torchaudio.__version__)" 2>&1 | tail -2
echo "=== 重启 api ==="
pkill -f "api_v2.py" 2>/dev/null || true; sleep 2
nohup .venv/bin/python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log" 2>&1 &
sleep 45
tail -3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log"
echo "=== 再试合成 ==="
time curl -s -m 300 -X POST -H "Content-Type: application/json" -d '{"text":"分析：链路已经打通，主人。"}' http://127.0.0.1:5599/fairy-voice/tts -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out3.pcm" -w "http=%{http_code} bytes=%{size_download}\n"
node -e "
const fs=require('fs');const b=fs.readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out3.pcm');let peak=0,sum=0,n=0;for(let i=0;i+1<b.length;i+=2){const v=b.readInt16LE(i)/32768;peak=Math.max(peak,Math.abs(v));sum+=v*v;n++;}
console.log(JSON.stringify({bytes:b.length,seconds:+(n/32000).toFixed(2),peak:+peak.toFixed(3),silent:peak<0.01}));"