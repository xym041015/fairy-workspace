set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
grep -iE "^error|failed|no matching" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/deps.log" | head -5 || echo "deps.log: 无错误"
echo "=== 关键导入检查 ==="
.venv/bin/python - <<'PY'
import importlib
mods = ["torch","torchaudio","numpy","scipy","librosa","soundfile","transformers","peft","fastapi","uvicorn","pytorch_lightning","jieba","jieba_fast","pypinyin","cn2an","g2p_en","wordsegment","split_lang","fast_langdetect","modelscope","x_transformers","torchmetrics","yaml","chardet","psutil","onnxruntime","ToJyutping","opencc","rotary_embedding_torch","yt_dlp"]
missing = []
for m in mods:
    try: importlib.import_module(m)
    except Exception as e: missing.append(m + " -> " + type(e).__name__ + ": " + str(e)[:60])
print("missing:", missing if missing else "none")
PY
echo "=== api_v2 直接启动探测 ==="
timeout_guard() { "$@" & p=$!; sleep 25; kill $p 2>/dev/null; wait $p 2>/dev/null; }
timeout_guard .venv/bin/python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml 2>&1 | head -25