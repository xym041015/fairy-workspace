set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"
export UV_PYTHON_INSTALL_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-python"
mkdir -p "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts"
nohup uv pip install --python .venv/bin/python --index-url https://pypi.tuna.tsinghua.edu.cn/simple 'scipy' 'librosa==0.10.2' 'numba' 'pytorch-lightning' 'ffmpeg-python' 'onnxruntime' 'tqdm' 'cn2an' 'pypinyin' 'g2p_en' 'sentencepiece' 'transformers>=4.51,<5' 'peft' 'chardet' 'PyYAML' 'psutil' 'jieba_fast' 'jieba' 'wordsegment' 'rotary_embedding_torch' 'ToJyutping' 'opencc' 'fastapi[standard]>=0.115.2' 'x_transformers' 'torchmetrics<=1.5' 'pydantic<=2.10.6' 'split-lang' 'fast_langdetect>=0.3.1' 'modelscope' 'soundfile' 'yt-dlp' > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/deps.log" 2>&1 &
echo "deps install started"
sleep 60
tail -4 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/deps.log"