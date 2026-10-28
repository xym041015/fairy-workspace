set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
B="https://www.modelscope.cn/models/XXXXRT/GPT-SoVITS-Pretrained/resolve/master"
echo "=== fast_langdetect 文件 ==="
curl -s -m 15 "https://www.modelscope.cn/api/v1/models/XXXXRT/GPT-SoVITS-Pretrained/repo/files?Revision=master&Root=pretrained_models/fast_langdetect" | python3 -c "
import sys, json
d = json.load(sys.stdin)
for f in d.get('Data', {}).get('Files', []): print(f['Path'], f.get('Size'))
"
mkdir -p GPT_SoVITS/pretrained_models/fast_langdetect
for f in $(curl -s -m 15 "https://www.modelscope.cn/api/v1/models/XXXXRT/GPT-SoVITS-Pretrained/repo/files?Revision=master&Root=pretrained_models/fast_langdetect" | python3 -c "
import sys, json
d = json.load(sys.stdin)
print(' '.join(f['Path'].split('/')[-1] for f in d.get('Data', {}).get('Files', []) if f.get('Size')))
"); do
  echo "downloading $f"
  curl -sL -o "GPT_SoVITS/pretrained_models/fast_langdetect/$f" "$B/pretrained_models/fast_langdetect/$f"
done
ls -l GPT_SoVITS/pretrained_models/fast_langdetect | head -5
echo "=== G2PWModel ==="
curl -sL -o /tmp/G2PWModel.zip "$B/G2PWModel.zip" && unzip -q -o /tmp/G2PWModel.zip -d GPT_SoVITS/text/ && ls GPT_SoVITS/text/G2PWModel | head -3
echo "=== 重启引擎并测试 ==="
pkill -f api_v2.py 2>/dev/null || true; sleep 3
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/start-voice-engine.sh" 2>&1 | tail -1
time curl -s -m 300 -X POST -H "Content-Type: application/json" -d '{"text":"分析：链路已经打通，主人。"}' http://127.0.0.1:5599/fairy-voice/tts -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out6.pcm" -w "http=%{http_code} bytes=%{size_download}\n"
node -e "
const fs=require('fs');const b=fs.readFileSync('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/clone-out6.pcm');let peak=0,sum=0,n=0;for(let i=0;i+1<b.length;i+=2){const v=b.readInt16LE(i)/32768;peak=Math.max(peak,Math.abs(v));sum+=v*v;n++;}
console.log(JSON.stringify({bytes:b.length,seconds:+(n/32000).toFixed(2),peak:+peak.toFixed(3),silent:peak<0.01}));"
grep -vE "^  File|^    " "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log" | tail -3