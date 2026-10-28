set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"
export UV_PYTHON_INSTALL_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-python"
export UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"
uv venv --python 3.10 .venv 2>&1 | tail -3
.venv/bin/python -V
echo "=== core deps (torch/torchaudio/numpy) ==="
time uv pip install --python .venv/bin/python torch torchaudio "numpy<2" 2>&1 | tail -6