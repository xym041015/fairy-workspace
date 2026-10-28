# Fairy-DSH → DeepSeek Harness 安装说明

上游仓库：https://github.com/Chengzhibense/Fairy-DSH （已克隆到本工作区 `Fairy-DSH/`，commit `d639887`）

---

## 1. 当前进度（已完成的部分）

| 事项 | 状态 |
|---|---|
| 仓库克隆到工作区 | ✅ `Fairy-DSH/` |
| 5 个插件各自的依赖安装（`dsh-fairy-contracts` + 第三方包） | ✅ |
| 隔离环境真机验证（DSH `0.1.5-rc.1`） | ✅ host 侧 5/5 `apply success`，client bundle 全部注册并可从服务器取回（200） |
| 安装脚本 `install-fairy-to-dsh.sh` | ✅ 安装 / 幂等重跑 / 冲突保护 / 回滚 / `--with-playwright` 全部自测通过 |

**唯一还没做的一步**：把它写进你真正的 `~/.dsh/profiles/web`。

原因是本会话的 DSH 文件沙箱是 `workspace-write`，只允许写这个工作区目录；对 `~/.dsh` 的任何写入都会被拒绝：

```
touch ~/.dsh/.write-test  →  touch: Operation not permitted
dsh --profile web --dump-config  →  Error: EPERM: open '.../.dsh/profiles/web/cordis.yml'
```

所以这一步需要你在**普通终端**里跑一条命令（路线 A），或者在 DSH 里让 agent 用已装的 `dsh-super-injector` 运行时注入（路线 B，免重启）。

---

## 2. 路线 A：持久安装（推荐）

在 macOS「终端」里执行（一条命令）：

```sh
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/install-fairy-to-dsh.sh"
```

脚本做的事：装各插件依赖 → 备份 `package.json` / `cordis.patch.yml` / `pnpm-lock.yaml` → 用 `dsh plugin --profile web add link:…` 把 5 个插件注册成 profile 依赖 → 往 `~/.dsh/profiles/web/cordis.patch.yml` 追加装配块 → 用 `dsh --profile web --dump-config` 校验装配树。

预期结尾：

```
[校验] 装配树
  OK   装配树校验通过（5 个插件均已入树）

完成。下一步：
  1. 退出并重新启动 DSH（dsh web 或桌面端）
  ...
```

然后**重启 DSH**（`package.json` / `cordis.patch.yml` 的改动只在重启后生效）。

其它参数：

```sh
bash install-fairy-to-dsh.sh --check              # 只体检，不改动任何文件
bash install-fairy-to-dsh.sh --with-playwright    # 额外装 @playwright/mcp，供 browser-dock 浏览器画面
bash install-fairy-to-dsh.sh --rollback           # 回到安装前（再用一次不带参数的脚本即可重装）
```

---

## 3. 路线 B：运行时注入（免重启，开发态）

你的 `web` profile 里已经常驻 `@dsh-external/dsh-super-injector`，可以在 DSH 会话里直接说：

```
dev_inject_plugin {"dir": "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual"}
dev_inject_plugin {"dir": ".../fairy-voice/dsh-fairy-voice"}
dev_inject_plugin {"dir": ".../fairy-startup/dsh-fairy-startup"}
dev_inject_plugin {"dir": ".../balance-meter/dsh-balance-meter"}
dev_inject_plugin {"dir": ".../browser-dock/dsh-browser-dock"}
```

卸载：`dev_uninject_plugin fairy-visual`（以此类推）。插件的 `node_modules` 已经装好，符合注入器「插件包必须自带依赖链接」的要求；改代码后注入器还会自动 watch 热重载。

（也可以在 设置 → 插件管理面板里把上面这几个插件目录拖进去内化，等同注入。）

---

## 4. 怎么确认装好了

1. 重启后打开 设置，多出 **Fairy Visual**、**Fairy Voice** 两个设置分区。
2. 侧边栏底部出现**余额卡**（`balance-meter`，读 `~/.dsh/.credentials.yaml` 里的 key，只在本机请求，不外传）。
3. 浏览器 DevTools 过滤 `DSH_FAIRY_LOG`，能看到各插件的自检日志。
4. 启动日志里应有 5 条 `apply success`（本次隔离测试实测）：

```
"module":"dsh-balance-meter","operation":"apply","outcome":"success"
"module":"dsh-browser-dock","operation":"apply","outcome":"success"
"module":"dsh-fairy-startup","operation":"apply","outcome":"success"
"module":"dsh-fairy-visual","operation":"apply","outcome":"success"
"module":"dsh-fairy-voice","operation":"apply","outcome":"success"
dsh web: http://127.0.0.1:52966
```

5. 页面里 5 个插件的 client bundle 都在（实测 `/plugins/??…/client.js` 组合请求 200）：

```
/plugins/??…,dsh-balance-meter/client.js,dsh-browser-dock/client.js,
dsh-fairy-startup/client.js,dsh-fairy-visual/client.js,dsh-fairy-voice/client.js&rev=…
```

---

## 5. 已知限制 / 注意事项

- **fairy-visual 默认关闭**（`enabled: false`），注册本身不会改变现有界面；要 HDD 大眼舞台需在设置里手动打开。
- **fairy-voice 需要本地 TTS**：默认打 `http://127.0.0.1:9880/tts`（GPT-SoVITS 风格），参考音频/提示词放在 `~/.dsh/fairy-voice/runtime/reference/fairy_ref.wav|txt`。缺失时只有文字播报回退，日志里会有一条 `reference.prompt.load … fallback: true` 的 warn —— 这是正常的，不是故障。
- **fairy-startup 会改变行为**：每个新浏览器文档回到空白会话而不是恢复上次会话。不想要就 `--rollback` 或从装配块里删掉 `fairy-startup`。
- **browser-dock 的浏览器画面**需要 `--with-playwright`（装 `@playwright/mcp@0.0.79`）。本机没装 Chrome，脚本会自动用 `msedge`；不需要画面就别开这个开关。
- **没有安装 `.agent-presets/fairy`（Fairy 人格预设）**：它的 `runtime/`、`world-core/` 属于未随仓库发布的私有资产，直接装会因缺模块报错。想用请先把私有资产放到 `Fairy-DSH/.agent-presets/fairy/` 下并设 `DSH_FAIRY_REPO_ROOT` 指向仓库根，再自行复制到 `~/.dsh/.agent-presets/fairy`。
- **`git pull` 更新仓库后不用重装**（profile 里是 `link:` 指向源码目录）；如果插件依赖有变化，重跑一次脚本即可（幂等，不会重复写装配块）。
- 装配块用注释标记（`# >>> fairy-dsh (install-fairy-to-dsh.sh) >>>`）识别；脚本会拒绝在同名 entry id 已存在时写入，因为 **重复 entry id 会让 DSH 启动直接失败**（实测：`duplicate loader entry id: balance-meter`）。
- 备份在 `~/.dsh/profiles/web/.fairy-install-backup/pre-install/`（首次安装前快照，重跑不会覆盖）。

---

## 6. 开发闭环

```sh
cd Fairy-DSH/fairy-visual/dsh-fairy-visual
# 改 src/…，重新打包 client bundle：
npx tsdown && cp lib/index.iife.js lib/client.js && cp src/index.js lib/index.js   # 等价于 npm run bundle
npm test
```

- 走**路线 A**：改完重启 DSH，或让 agent 用注入器 `dev_reload_package` 热重载。
- 走**路线 B**：注入器自带 watch，build 完约 1.5 秒自动重载。
- 各插件测试：`cd Fairy-DSH/<plugin>/dsh-<name> && npm test`；整体离线验收工具在 `Fairy-DSH/fairy-system/`（`check.sh`、`verify.js`）。

## 7. 工作区文件清单

```
install-fairy-to-dsh.sh     # 安装 / --check / --rollback / --with-playwright
FAIRY-INSTALL.md            # 本文件
Fairy-DSH/                  # 上游仓库 clone（各插件 node_modules 已装好）
.pnpm-store/                # pnpm 存储（本沙箱内 install 用；删掉会让 node_modules 失效）
```
