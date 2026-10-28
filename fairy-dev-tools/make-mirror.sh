#!/usr/bin/env bash
# 复现用镜像实例：复制你真实 profile 的配置 + 软链你的 node_modules，跑在独立 DSH_HOME
set -euo pipefail
WS="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发"
T="$WS/fairy-dev-tools"
M="$T/mirror"
rm -rf "$M"; mkdir -p "$M/home/profiles/web"
cp ~/.dsh/profiles/web/package.json "$M/home/profiles/web/package.json"
cp ~/.dsh/profiles/web/cordis.patch.yml "$M/home/profiles/web/cordis.patch.yml"
cp ~/.dsh/profiles/web/pnpm-workspace.yaml "$M/home/profiles/web/pnpm-workspace.yaml"
printf "[]\n" > "$M/home/profiles/web/cordis.yml"
ln -s ~/.dsh/profiles/web/node_modules "$M/home/profiles/web/node_modules"
cp ~/.dsh/settings.yaml "$M/home/settings.yaml" 2>/dev/null || true
mkdir -p "$M/home/storages" && cp ~/.dsh/storages/workspace.json "$M/home/storages/workspace.json"
cd "$WS"
(DSH_HOME="$M/home" nohup dsh --profile web --no-open --port 5599 > "$M/boot.log" 2>&1 &)
sleep 22
grep -o "dsh web: http://127.0.0.1:[0-9]*/?token=[A-Za-z0-9_-]*" "$M/boot.log" | tail -1
echo "浏览器：bash $T/browser.sh <url>"