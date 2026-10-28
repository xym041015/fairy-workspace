#!/usr/bin/env bash
# 同步 Fairy 人格预设到 ~/.dsh(DSH 只认真实目录,不接受软链)。
# 用法:bash sync-fairy-preset.sh
# 说明:预设加载 ./runtime/index.js 等相对路径,因此 runtime 也从 ~/.dsh 副本加载——
#       改了仓库里的 runtime 或预设配置/资产后,都要跑一次本脚本。
set -euo pipefail
REPO="${DSH_FAIRY_REPO_ROOT:-/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH}"
DEST="$HOME/.dsh/.agent-presets/fairy"
[ -d "$REPO/.agent-presets/fairy" ] || { echo "仓库预设不存在: $REPO/.agent-presets/fairy" >&2; exit 1; }
rm -rf "$DEST"
cp -R "$REPO/.agent-presets/fairy" "$DEST"
echo "已同步: $DEST"
echo "重启 DSH 后生效(预设列表在启动时扫描)。"
