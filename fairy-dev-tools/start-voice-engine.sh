#!/usr/bin/env bash
# 启动 Fairy 本音引擎（GPT-SoVITS api_v2，CPU）
set -euo pipefail
T="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools"
cd "$T/tts/GPT-SoVITS"
export HOME="$T/tts/home"
export TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1
if lsof -ti tcp:9880 -sTCP:LISTEN >/dev/null 2>&1; then echo "already running on 9880"; exit 0; fi
nohup .venv/bin/python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml > "$T/tts/api.log" 2>&1 &
for i in $(seq 1 60); do
  if curl -fsS -m 2 http://127.0.0.1:9880/docs >/dev/null 2>&1; then echo "fairy voice engine up: http://127.0.0.1:9880"; exit 0; fi
  sleep 2
done
echo "engine did not start; see $T/tts/api.log" >&2; exit 1