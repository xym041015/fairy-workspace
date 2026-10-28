set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"
export HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/home"; mkdir -p "$HOME"
nohup uv pip install --python .venv/bin/python --index-url https://pypi.tuna.tsinghua.edu.cn/simple funasr > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/funasr.log" 2>&1 &
echo "funasr install started"
sleep 45
tail -3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/funasr.log"
.venv/bin/python -c "import funasr; print('funasr', funasr.__version__)" 2>&1 | tail -2
echo "=== 模型下载进度 ==="
du -sh GPT_SoVITS/pretrained_models; tail -2 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/dl.log"