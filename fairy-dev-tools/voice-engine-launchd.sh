#!/usr/bin/env bash
# LaunchAgent 入口：GPT-SoVITS 引擎前台运行（launchd 负责存活）。
# 端口已被其它实例占用时干净退出 0，配合 KeepAlive.SuccessfulExit=false 防止重启循环。
# 引擎实体位于 ~/Library/Application Support/fairy-tts（launchd 无桌面 TCC 权限，
# 不能放 Desktop；fairy-dev-tools/tts 是指向此处的软链，供终端脚本沿用）。
set -euo pipefail
T="$HOME/Library/Application Support/fairy-tts"
ENGINE_DIR="$T/GPT-SoVITS"
export HOME="$T/home"
export TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1
if lsof -ti tcp:9880 -sTCP:LISTEN >/dev/null 2>&1; then
  echo "$(date '+%F %T') port 9880 already in use; exiting cleanly" >&2
  exit 0
fi
cd "$ENGINE_DIR"
exec .venv/bin/python api_v2.py -a 127.0.0.1 -p 9880 -c GPT_SoVITS/configs/tts_infer.yaml
