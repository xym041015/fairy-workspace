#!/usr/bin/env bash
# Fairy-DSH -> DSH profile installer / rollback.
#
#   bash install-fairy-to-dsh.sh              install into the "web" profile
#   bash install-fairy-to-dsh.sh --check      read-only status report
#   bash install-fairy-to-dsh.sh --rollback   restore the pre-install profile files
#   bash install-fairy-to-dsh.sh --uninstall  remove fairy-dsh from the profile (precise reverse of install)
#   bash install-fairy-to-dsh.sh --update     git pull + reinstall deps + rebuild bundles + regression tests
#
# Options: --profile <name>  --repo <path>  --with-playwright  --without-playwright  --help
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=${FAIRY_REPO_ROOT:-"$SCRIPT_DIR/Fairy-DSH"}
DSH_HOME=${DSH_HOME:-"$HOME/.dsh"}
PROFILE=${DSH_PROFILE:-web}
WITH_PLAYWRIGHT=1
MODE=install

PLUGINS=(
  "balance-meter/dsh-balance-meter"
  "browser-dock/dsh-browser-dock"
  "fairy-startup/dsh-fairy-startup"
  "fairy-visual/dsh-fairy-visual"
  "fairy-voice/dsh-fairy-voice"
)
ENTRY_IDS=(balance-meter browser-dock fairy-startup fairy-visual fairy-voice)
MARK_BEGIN='# >>> fairy-dsh (install-fairy-to-dsh.sh) >>>'
MARK_END='# <<< fairy-dsh (install-fairy-to-dsh.sh) <<<'
MCP_BEGIN='# >>> fairy-dsh browser MCP (install-fairy-to-dsh.sh) >>>'
MCP_END='# <<< fairy-dsh browser MCP (install-fairy-to-dsh.sh) <<<'

usage() {
  sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE=${2:?--profile needs a value}; shift 2 ;;
    --repo) REPO_ROOT=${2:?--repo needs a value}; shift 2 ;;
    --with-playwright) WITH_PLAYWRIGHT=1; shift ;;
    --without-playwright) WITH_PLAYWRIGHT=0; shift ;;
    --check) MODE=check; shift ;;
    --rollback) MODE=rollback; shift ;;
    --uninstall) MODE=uninstall; shift ;;
    --update) MODE=update; shift ;;
    -h|--help) usage ;;
    *) echo "unknown option: $1" >&2; usage ;;
  esac
done

PROFILE_DIR="$DSH_HOME/profiles/$PROFILE"
PATCH_FILE="$PROFILE_DIR/cordis.patch.yml"
BACKUP_DIR="$PROFILE_DIR/.fairy-install-backup/pre-install"

ok()   { printf '  \033[32mOK\033[0m   %s\n' "$*"; }
bad()  { printf '  \033[31mFAIL\033[0m %s\n' "$*"; }
info() { printf '  --   %s\n' "$*"; }
step() { printf '\n[%s] %s\n' "$1" "$2"; }

plugin_pkg_name() { python3 -c "import json,sys;print(json.load(open(sys.argv[1]))['name'])" "$REPO_ROOT/$1/package.json"; }

preflight() {
  step 1/5 "preflight"
  [ -d "$REPO_ROOT/fairy-contracts" ] || { bad "Fairy-DSH 仓库不存在: $REPO_ROOT"; exit 1; }
  [ -d "$PROFILE_DIR" ] || { bad "profile 不存在: $PROFILE_DIR"; exit 1; }
  command -v dsh >/dev/null || { bad "dsh CLI 不在 PATH"; exit 1; }
  command -v pnpm >/dev/null || { bad "pnpm 不在 PATH"; exit 1; }
  ok "repo:    $REPO_ROOT"
  ok "profile: $PROFILE_DIR"
}

install_plugin_deps() {
  step 2/5 "安装各插件自身的依赖（dsh-fairy-contracts + 第三方包）"
  for rel in "${PLUGINS[@]}"; do
    ( cd "$REPO_ROOT/$rel" && pnpm install --frozen-lockfile --ignore-scripts >/dev/null 2>&1 ) \
      && ok "$rel" || { bad "$rel pnpm install 失败"; exit 1; }
  done
}

backup_profile() {
  step 3/5 "备份 profile 文件"
  if [ -d "$BACKUP_DIR" ]; then
    info "已有安装前备份，保留: $BACKUP_DIR"
    return
  fi
  mkdir -p "$BACKUP_DIR"
  for f in package.json cordis.patch.yml pnpm-lock.yaml; do
    [ -f "$PROFILE_DIR/$f" ] && cp -p "$PROFILE_DIR/$f" "$BACKUP_DIR/$f" && info "$f"
  done
  ok "备份目录: $BACKUP_DIR"
}

link_dependencies() {
  step 4/5 "把插件作为 link: 依赖注册进 profile"
  for rel in "${PLUGINS[@]}"; do
    dsh plugin --profile "$PROFILE" add "link:$REPO_ROOT/$rel" >/dev/null 2>&1 \
      && ok "$(plugin_pkg_name "$rel")" || { bad "$rel 注册失败"; exit 1; }
  done
  if [ "$WITH_PLAYWRIGHT" = 1 ]; then
    dsh plugin --profile "$PROFILE" add '@playwright/mcp@0.0.79' >/dev/null 2>&1 \
      && ok '@playwright/mcp@0.0.79' || { bad '@playwright/mcp 安装失败'; exit 1; }
  fi
}

write_patch_entries() {
  step 5/5 "写入 cordis.patch.yml 装配条目"
  if grep -qF "$MARK_BEGIN" "$PATCH_FILE"; then
    info "已存在 fairy-dsh 装配块，跳过"
  else
    for id in "${ENTRY_IDS[@]}"; do
      if grep -qE "^[[:space:]]*-[[:space:]]*id:[[:space:]]*${id}[[:space:]]*$" "$PATCH_FILE"; then
        bad "已存在同名 entry id: ${id} —— 重复 entry id 会导致 DSH 启动失败，请先人工清理"
        exit 1
      fi
    done
    [ -s "$PATCH_FILE" ] && printf '\n' >> "$PATCH_FILE"
    cat >> "$PATCH_FILE" <<EOF
$MARK_BEGIN
- insert:
    - id: balance-meter
      name: 'dsh-balance-meter'
      inject: [clientModules]

    - id: browser-dock
      name: 'dsh-browser-dock'
      inject: [clientModules]

    - id: fairy-startup
      name: 'dsh-fairy-startup'
      inject: [clientModules]

    - id: fairy-voice
      name: 'dsh-fairy-voice'
      inject: [clientModules]

    - id: fairy-visual
      name: 'dsh-fairy-visual'
      inject: [clientModules]
$MARK_END
EOF
    ok "装配块已追加"
  fi

  if [ "$WITH_PLAYWRIGHT" = 1 ]; then
    if grep -qF "$MCP_BEGIN" "$PATCH_FILE"; then
      info "已存在 browser MCP 块，跳过"
    else
      browser=chrome
      [ -d "/Applications/Google Chrome.app" ] || browser=msedge
      cat >> "$PATCH_FILE" <<EOF

$MCP_BEGIN
- insert:
    - id: mcp-playwright
      name: '@deepseek-ai/dsh-mcp-client'
      config:
        serverName: playwright
        transport: stdio
        command: '$REPO_ROOT/browser-dock/dsh-browser-dock/proxy.cjs'
        args: ['--browser', '$browser', '--headless', '--user-data-dir', '$DSH_HOME/playwright-profile']
$MCP_END
EOF
      ok "browser MCP 块已追加（browser=${browser}）"
    fi
  fi
}

validate() {
  local tmp
  tmp=$(mktemp)
  if dsh --profile "$PROFILE" --dump-config >"$tmp" 2>/dev/null; then
    local missing=0
    for pkg in "${ENTRY_IDS[@]}"; do
      grep -q "dsh-$pkg" "$tmp" || { bad "装配树里没有 dsh-$pkg"; missing=1; }
    done
    [ "$missing" = 0 ] && ok "装配树校验通过（5 个插件均已入树）"
  else
    bad "dsh --dump-config 失败，请手动检查 $PATCH_FILE"
  fi
  rm -f "$tmp"
}

do_check() {
  local fails=0
  printf 'Fairy-DSH 安装状态检查\n'
  [ -d "$REPO_ROOT/fairy-contracts" ] && ok "仓库: $REPO_ROOT" || { bad "仓库缺失"; fails=1; }
  [ -d "$PROFILE_DIR" ] && ok "profile: $PROFILE_DIR" || { bad "profile 缺失"; fails=1; }
  for rel in "${PLUGINS[@]}"; do
    [ -d "$REPO_ROOT/$rel/node_modules/dsh-fairy-contracts" ] && ok "$rel 依赖已装" || { bad "$rel 依赖未装"; fails=1; }
  done
  [ -f "$PROFILE_DIR/package.json" ] && python3 - "$PROFILE_DIR/package.json" "$REPO_ROOT" "${PLUGINS[@]}" <<'PY' || fails=1
import json, sys
data = json.load(open(sys.argv[1]))
deps = data.get('dependencies', {})
missing = [d.split('/')[-1] for d in sys.argv[3:] if d.split('/')[-1] not in deps]
if missing:
    print('  FAIL package.json 缺少 link 依赖: ' + ', '.join(missing)); sys.exit(1)
print('  OK   package.json 5 个 link 依赖齐备')
PY
  if [ -f "$PATCH_FILE" ] && grep -qF "$MARK_BEGIN" "$PATCH_FILE"; then
    ok "cordis.patch.yml 已含 fairy-dsh 装配块"
  else
    bad "cordis.patch.yml 未含 fairy-dsh 装配块"; fails=1
  fi
  for rel in "${PLUGINS[@]}"; do
    local name; name=$(plugin_pkg_name "$rel")
    [ -e "$PROFILE_DIR/node_modules/$name" ] && ok "node_modules/$name" || { bad "node_modules/$name 缺失"; fails=1; }
  done
  [ "$fails" = 0 ] && printf '\n结论: 已安装\n' || printf '\n结论: 未安装完整（跑一次不带参数的脚本即可安装）\n'
  exit "$fails"
}

do_rollback() {
  [ -d "$BACKUP_DIR" ] || { bad "找不到安装前备份 $BACKUP_DIR"; exit 1; }
  printf '回滚到安装前状态（来源 %s）\n' "$BACKUP_DIR"
  for f in package.json cordis.patch.yml pnpm-lock.yaml; do
    if [ -f "$BACKUP_DIR/$f" ]; then cp -p "$BACKUP_DIR/$f" "$PROFILE_DIR/$f" && ok "恢复 $f"; fi
  done
  dsh plugin --profile "$PROFILE" install >/dev/null 2>&1 && ok "profile 依赖已重置" || info "pnpm install 未成功，请手动执行"
  printf '\n重启 DSH 后生效。插件源码目录未改动，可随时重新安装。\n'
}

do_uninstall() {
  [ -f "$PATCH_FILE" ] || { bad "找不到 $PATCH_FILE"; exit 1; }
  printf '从 profile %s 精确卸载 fairy-dsh（插件源码与备份均保留）\n' "$PROFILE_DIR"

  step 1/3 "移除 cordis.patch.yml 中的 fairy-dsh 装配块"
  python3 - "$PATCH_FILE" "$MARK_BEGIN" "$MARK_END" "$MCP_BEGIN" "$MCP_END" <<'PY'
import sys
path = sys.argv[1]
blocks = [(sys.argv[2], sys.argv[3]), (sys.argv[4], sys.argv[5])]
text = open(path).read()
changed = False
for begin, end in blocks:
    i = text.find(begin)
    if i < 0:
        print('  --   块不存在（跳过）: ' + begin.split('(')[0].strip(' #> '))
        continue
    j = text.find(end, i)
    if j < 0:
        raise SystemExit(f'结束标记缺失，请人工检查: {begin}')
    j += len(end)
    if i >= 2 and text[i-2:i] == '\n\n':
        i -= 1
    text = text[:i] + text[j:]
    changed = True
    print('  OK   已移除块: ' + begin.split('(')[0].strip(' #> '))
if changed:
    open(path, 'w').write(text)
PY

  step 2/3 "从 package.json 移除本仓库的 link 依赖并刷新 node_modules"
  python3 - "$PROFILE_DIR/package.json" "$REPO_ROOT" "${PLUGINS[@]}" <<'PY'
import json, sys
path, repo = sys.argv[1], sys.argv[2]
data = json.load(open(path))
deps = data.get('dependencies', {})
removed = []
for rel in sys.argv[3:]:
    name = json.load(open(f'{repo}/{rel}/package.json'))['name']
    if deps.get(name) == f'link:{repo}/{rel}':
        del deps[name]
        removed.append(name)
if removed:
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
for name in removed:
    print(f'  OK   已移除依赖 {name}')
if not removed:
    print('  --   无本仓库 link 依赖（可能已卸载）')
PY
  for rel in "${PLUGINS[@]}"; do
    local name; name=$(plugin_pkg_name "$rel")
    if [ -L "$PROFILE_DIR/node_modules/$name" ]; then
      rm "$PROFILE_DIR/node_modules/$name" && info "移除 node_modules/$name"
    fi
  done
  dsh plugin --profile "$PROFILE" install >/dev/null 2>&1 && ok "profile 依赖已刷新（lockfile 同步）" || info "dsh plugin install 未成功，可手动执行一次"

  step 3/3 "校验装配树"
  local tmp; tmp=$(mktemp)
  if dsh --profile "$PROFILE" --dump-config >"$tmp" 2>/dev/null; then
    local leftover=0
    for id in "${ENTRY_IDS[@]}"; do
      grep -q "dsh-$id" "$tmp" && { bad "装配树里仍有 dsh-$id（重启 DSH 后复查）"; leftover=1; }
    done
    [ "$leftover" = 0 ] && ok "装配树已无 fairy-dsh 条目"
  else
    info "dsh --dump-config 失败，请人工检查 $PATCH_FILE"
  fi
  rm -f "$tmp"
  cat <<EOF

卸载完成。
  1. 重启 DSH（config 层改动需要重启；客户端 bundle 随链接移除即刻失效）。
  2. 插件源码保留在 ${REPO_ROOT} ，可随时重新安装。
  3. 如需连安装前备份一起清掉：rm -rf "$BACKUP_DIR"
EOF
}

do_update() {
  preflight
  step 1/4 "拉取上游更新"
  if git -C "$REPO_ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    [ -n "$(git -C "$REPO_ROOT" status --porcelain)" ] && info "工作区含本地修复改动，--ff-only 拉取失败时会保留本地版本"
    if git -C "$REPO_ROOT" pull --ff-only >/dev/null 2>&1; then
      ok "git pull 成功: $(git -C "$REPO_ROOT" log -1 --format='%h %s' | cut -c1-60)"
    else
      info "git pull --ff-only 失败（本地改动/分叉/无网络），保留本地版本继续"
    fi
  else
    info "不是 git 仓库，跳过拉取"
  fi

  step 2/4 "刷新各插件依赖"
  for rel in "${PLUGINS[@]}"; do
    ( cd "$REPO_ROOT/$rel" && pnpm install --frozen-lockfile --ignore-scripts >/dev/null 2>&1 ) \
      && ok "$rel" || { bad "$rel pnpm install 失败"; exit 1; }
  done

  step 3/4 "重建 client bundle（browser-dock / fairy-visual）"
  for rel in "browser-dock/dsh-browser-dock" "fairy-visual/dsh-fairy-visual"; do
    ( cd "$REPO_ROOT/$rel" && pnpm run bundle >/dev/null 2>&1 ) \
      && ok "$rel" || bad "$rel bundle 构建失败（保留旧 bundle，请人工检查）"
  done

  step 4/4 "回归测试 + 装配校验"
  local failed=0
  for rel in "balance-meter/dsh-balance-meter" "fairy-visual/dsh-fairy-visual" "fairy-voice/dsh-fairy-voice"; do
    if ( cd "$REPO_ROOT/$rel" && npm test >/dev/null 2>&1 ); then
      ok "$rel npm test"
    else
      bad "$rel npm test 失败（bundle 未回退，请查看该插件测试输出）"; failed=1
    fi
  done
  write_patch_entries
  validate
  [ "$failed" = 0 ] || exit 1
  cat <<EOF

更新完成。客户端 bundle 改动刷新页面（Cmd+R）即生效；装配/配置改动需重启 DSH。
EOF
}

case "$MODE" in
  check) do_check ;;
  rollback) do_rollback ;;
  uninstall) do_uninstall ;;
  update) do_update ;;
  install)
    preflight
    install_plugin_deps
    backup_profile
    link_dependencies
    write_patch_entries
    printf '\n[校验] 装配树\n'
    validate
    cat <<EOF

完成。下一步：
  1. 退出并重新启动 DSH（dsh web 或桌面端）——本目录改动只在重启后生效。
  2. 打开 设置，应能看到 Fairy Visual / Fairy Voice 的设置分区；侧边栏底部出现余额卡。
  3. 回滚：bash "$(basename "$0")" --rollback
EOF
    ;;
esac
