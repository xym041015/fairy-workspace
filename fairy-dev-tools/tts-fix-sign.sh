set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
echo "=== macOS 版本 ==="; sw_vers | tr '\n' ' '; echo
echo "=== 重签名 venv 内所有 .so/.dylib ==="
COUNT=0
while IFS= read -r f; do codesign --force --sign - "$f" >/dev/null 2>&1 && COUNT=$((COUNT+1)); done < <(find .venv -type f \( -name "*.so" -o -name "*.dylib" \) 2>/dev/null)
echo "resigned: $COUNT files"
echo "=== 重新检查导入 ==="
.venv/bin/python - <<'PY'
import importlib
mods = ["scipy.signal","torchmetrics","pytorch_lightning","peft","librosa","transformers","fastapi","split_lang","fast_langdetect","onnxruntime","modelscope"]
for m in mods:
    try:
        importlib.import_module(m); print("ok  ", m)
    except Exception as e:
        print("FAIL", m, type(e).__name__, str(e)[:120])
PY