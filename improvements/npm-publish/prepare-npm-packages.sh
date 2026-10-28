#!/usr/bin/env bash
# Stage the Fairy-DSH packages for npm publish.
#
#   bash prepare-npm-packages.sh [scope]
#     scope: 可选,npm scope 名(如 my-name → 发布为 @my-name/dsh-*)。
#            缺省发布为无 scope 包名(dsh-fairy-contracts 等,需要对应名字未被占用)。
#
# 产出:improvements/npm-publish/staging/<pkg>/,每个目录内可直接 `npm publish --access public`。
# 注意:
#   - @deepseek-ai/* 是 DSH 宿主私有包、未发布 npm → 移到 peerDependencies,
#     安装方需在 DSH 环境内使用(宿主自带这些模块)。
#   - link: 依赖(dsh-fairy-contracts)改写为 registry 依赖(contracts 包一并发布)。
set -euo pipefail

WS="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发"
REPO="$WS/Fairy-DSH"
OUT="$WS/improvements/npm-publish/staging"
SCOPE="${1:-}"

PACKAGES=(
  "fairy-contracts"
  "balance-meter/dsh-balance-meter"
  "browser-dock/dsh-browser-dock"
  "fairy-startup/dsh-fairy-startup"
  "fairy-visual/dsh-fairy-visual"
  "fairy-voice/dsh-fairy-voice"
)

rm -rf "$OUT"; mkdir -p "$OUT"
CONTRACTS_VERSION=$(python3 -c "import json;print(json.load(open('$REPO/fairy-contracts/package.json'))['version'])")

for rel in "${PACKAGES[@]}"; do
  name=$(python3 -c "import json;print(json.load(open('$REPO/$rel/package.json'))['name'])")
  src="$REPO/$rel"
  dest="$OUT/${SCOPE:+@${SCOPE}/}$name"
  mkdir -p "$dest"
  (cd "$src" && tar cf - --exclude node_modules --exclude '*.iife.js' .) | (cd "$dest" && tar xf -)
  cd "$dest"
  NAME="$name" SCOPE="$SCOPE" CONTRACTS_VERSION="$CONTRACTS_VERSION" python3 <<'PY'
import json, os

path = 'package.json'
data = json.load(open(path))
name, scope, contracts_version = os.environ['NAME'], os.environ['SCOPE'], os.environ['CONTRACTS_VERSION']

data.pop('private', None)
data['name'] = f"@{scope}/{name}" if scope else name
data.setdefault('version', '0.1.0')
data['publishConfig'] = {'access': 'public'}

base = os.getcwd()
candidates = ['lib', 'src', 'proxy.cjs', 'README.md', 'LICENSE']
candidates += [f for f in os.listdir(base) if f.endswith(('.js', '.cjs', '.mjs')) and os.path.isfile(os.path.join(base, f))]
data['files'] = [f for f in candidates if os.path.exists(os.path.join(base, f))] or ['lib']

deps = data.get('dependencies', {})
for dep, value in list(deps.items()):
    if isinstance(value, str) and value.startswith('link:'):
        deps[dep] = f"^{contracts_version}"

peers = data.setdefault('peerDependencies', {})
for dep in [d for d in deps if d.startswith('@deepseek-ai/')]:
    peers[dep] = deps.pop(dep)
if not peers:
    data.pop('peerDependencies', None)
if not deps:
    data.pop('dependencies', None)

json.dump(data, open(path, 'w'), indent=2, ensure_ascii=False)
open(path, 'a').write('\n')
print(f"staged {data['name']} (peers: {', '.join(peers) or 'none'})")
PY
  cd - > /dev/null
done

cat <<EOF

完成。发布步骤见 improvements/npm-publish/PUBLISH.md:
  1. npm login
  2. for d in improvements/npm-publish/staging/*/; do (cd "\$d" && npm publish --access public); done
EOF
