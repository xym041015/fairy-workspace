set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"
for v in 1.13.1 1.16.3 1.14.1; do
  echo "=== trying scipy==$v ==="
  uv pip install --python .venv/bin/python --index-url https://pypi.tuna.tsinghua.edu.cn/simple "scipy==$v" >/dev/null 2>&1 || { echo "install failed"; continue; }
  if .venv/bin/python -c "import scipy.signal" 2>/dev/null; then echo "OK scipy==$v works"; break; else echo "scipy==$v still fails"; fi
done
.venv/bin/python -c "import scipy; print('final scipy', scipy.__version__)" 2>/dev/null || echo "no working scipy yet"