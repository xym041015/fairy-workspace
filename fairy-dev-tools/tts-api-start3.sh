set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"; export HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/home"
uv pip install --python .venv/bin/python --index-url https://pypi.tuna.tsinghua.edu.cn/simple matplotlib tensorboard pyloudnorm 2>&1 | tail -2
echo "=== 重试启动 ==="
nohup .venv/bin/python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log" 2>&1 &
sleep 40
tail -6 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log"