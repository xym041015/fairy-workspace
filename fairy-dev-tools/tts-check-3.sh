set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export UV_CACHE_DIR="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/.uv-cache"
export NLTK_DATA="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/nltk_data"
mkdir -p "$NLTK_DATA"
echo "=== 剩余导入检查 ==="
.venv/bin/python - <<'PY'
import importlib
for m in ["scipy.signal","torchmetrics","pytorch_lightning","peft","numba","llvmlite","onnxruntime","g2p_en","pyopenjtalk","jieba_fast","split_lang","ToJyutping","opencc","wordsegment","rotary_embedding_torch","x_transformers"]:
    try:
        importlib.import_module(m); print("ok  ", m)
    except Exception as e:
        print("FAIL", m, type(e).__name__, str(e)[:90])
PY
echo "=== 尝试装 pyopenjtalk（可能需要编译）==="
uv pip install --python .venv/bin/python --index-url https://pypi.tuna.tsinghua.edu.cn/simple pyopenjtalk 2>&1 | tail -3