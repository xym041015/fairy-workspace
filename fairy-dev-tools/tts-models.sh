set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"
export MODELSCOPE_CACHE="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/ms-cache"
nohup .venv/bin/python -m modelscope download --model AI-ModelScope/GPT-SoVITS --local_dir GPT_SoVITS/pretrained_models --include 'chinese-roberta-wwm-ext-large/*' 'chinese-hubert-base/*' 'gsv-v2final-pretrained/*' > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/models.log" 2>&1 &
echo "model download started"
sleep 40
tail -3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/models.log"; du -sh GPT_SoVITS/pretrained_models 2>/dev/null