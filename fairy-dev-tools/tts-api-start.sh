set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
ls -l GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large/pytorch_model.bin 2>/dev/null | awk '{printf "roberta: %d bytes\n", $5}'
echo "=== 切 22s 参考片段（先做端到端验证）==="
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
ffmpeg -v error -y -ss 24.5 -t 22 -i fairy_raw.wav -ac 1 -ar 32000 -af "loudnorm=I=-18:TP=-2" fairy_ref_candidate.wav
ffprobe -v error -show_entries format=duration -of default=nw=1 fairy_ref_candidate.wav
echo "=== 配置改 CPU / v2 ==="
cd GPT-SoVITS </dev/null
python3 - <<'PY'
import pathlib
p = pathlib.Path("GPT_SoVITS/configs/tts_infer.yaml")
s = p.read_text()
s = s.replace("  device: cuda
  is_half: true", "  device: cpu
  is_half: false")
p.write_text(s)
print([l for l in s.splitlines() if "device" in l or "is_half" in l][:4])
PY
echo "=== 启动 api_v2 ==="
export HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/home"; mkdir -p "$HOME"
nohup .venv/bin/python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log" 2>&1 &
echo "api started"
sleep 60
tail -12 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/api.log"