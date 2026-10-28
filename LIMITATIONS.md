# Fairy-DSH 安装限制清单(待你逐条指派)

生成时间:2026-09-17 · 对应仓库 commit `d639887` · DSH `0.1.5-rc.1` · profile `web`
**状态更新:2026-09-18**(ZCode 会话逐条复核;✅=已解决/已实测,🔶=部分改善,⬜=仍待处理)
**二次更新:2026-09-18 晚**(A7 备妥/A8 采纳/A10 重建安装/B2 默认开启,详见文末第 8 轮记录)

## 本轮(9-18)新增完成

| 项 | 结果 |
|---|---|
| A6 | ✅ `install-fairy-to-dsh.sh --uninstall`:精确移除装配块 + 本仓库 link 依赖 + node_modules 链接并刷新 lockfile;幂等可重跑(临时 profile 实测) |
| B10 | ✅ `--update`:git pull(--ff-only,失败则保留本地版本)→ 刷新依赖 → 重建 browser-dock/fairy-visual bundle → 三插件回归测试 → 装配校验(临时 profile 实测) |
| B4(补充) | ✅ GPT-SoVITS 引擎 LaunchAgent 开机自启 + 崩溃自愈(实测 kill -9 后 24s 复活);引擎实体已移至 `~/Library/Application Support/fairy-tts`(launchd 无桌面 TCC 权限) |
| B5 | ✅ fairy-voice 全部路径统一走 `FAIRY_HOME`(本轮修掉 `voice-brain.json` 残留的 `homedir()` 硬编码);参考音频另支持 `DSH_FAIRY_REFERENCE_DIR` |
| B7 | ✅ 汇率/价目可覆盖:`$DSH_HOME/balance-meter/pricing.json`(逐字段,非法值自动回退默认)+ 环境变量 `DSH_FAIRY_USD_CNY`;默认行为不变 |
| B11 | ✅ 体积实测:5 插件 client bundle 合计 ≈590KB raw / ≈120KB gzip(fairy-visual 461KB/85KB 为大头,合并单请求、首载后缓存);本地化/无障碍未动 |
| 附带修复 | fairy-system 测试的 2 处 URL 编码路径 bug(中文路径必 ENOENT,与上轮 capability.test.js 同类);check.sh 对缺失的私有 `.agent-presets` 资产改为按存在性跳过;preflight 新增 `DSH_APPROVED_DSH_VERSION`+`DSH_APPROVED_RUNTIME_SHA256` 成对 env 覆盖(缺一不生效,fail-closed) |

## A. 安装机制与环境

| # | 限制(现状) | 影响 | 可能的改法 | 状态 |
|---|---|---|---|---|
| A1 | bash 沙箱对 `~/.dsh` 的写权限随会话配置而定(9-17 会话 EPERM;9-18 会话实测可写;`dev_*` 注入口并非每会话暴露) | 不同会话里我能代改的范围不同 | 写权限被拒时:你终端跑脚本,或走注入口 | 🔶 环境相关,已验证两条路线 |
| A2 | `dsh plugin add` 只把包装成普通依赖,不会自动装配 | 必须写 `cordis.patch.yml` 的 `- insert:` 条目(脚本已做) | 生态固有 | ⬜ 固有,已绕开 |
| A3 | 重复 entry id 会让 DSH 启动直接崩溃 | 手动/重复安装会开不了机 | 脚本幂等标记+冲突保护;`dev_fix_patch` 可按 id 去重 | ⬜ 固有,已绕开 |
| A4 | 配置/装配改动需重启 DSH;**client bundle 改动刷新页面(Cmd+R)即生效**(9-18 实测:宿主每次页面加载按磁盘内容重算 rev) | 改 UI 源码无需重启,改装配需重启 | — | 🔶 已收窄并实测 |
| A5 | 每个插件必须自带 node_modules(`link:` 的依赖不会被 profile 安装) | 仓库目录不能随意搬动;git pull 后要重装依赖 | `--update` 已做刷新 | ⬜ 固有 |
| A6 | 无独立卸载入口 | 回滚不精确 | — | ✅ 已解决:`--uninstall` |
| A7 | 上游仓库 `private: true`,五插件未发布 npm | 只能本地 link/注入 | — | ✅ 已备妥:`improvements/npm-publish/`(6 包 staging+脚本+指引),npm 登录后按 PUBLISH.md 执行即可 |
| A8 | 仓库自带 `profiles/web` 模板含 `danger-full-access`/`never` 审批等降安全配置 | 已按你确认采纳(备份在 `.fairy-install-backup/pre-template-20260918/`) | 模板的 `dsh-message-edit` bundle 与 DSH 0.1.5-rc.1 构建期 externals 漂移不兼容(实测加载失败),已从 bundles 摘除并留档;其余(安全三件套/context7/补丁)已生效 | ✅ 已采纳(含一处必要偏差) |
| A9 | pnpm store 落在工作区 `.pnpm-store`(69MB) | 删掉会让各插件 node_modules 失效 | 迁移需整体重装依赖 | ⬜ 低收益,保留现状 |
| A10 | `runtime/`+`world-core/` 从未进 git 历史(人格内容资产全部公开且在工作区) | 缺 runtime 预设装不上 | — | ✅ 已解决:按公开契约重建 runtime(fairy_core.py/index.js/safety-gate.js/world-knowledge.js,Python+Node 测试全绿);DSH 实测**只认真实目录预设**,已物化安装并在镜像验证出现在预设列表;world-core 游戏语料缺失→检索如实降级不编造 |
| A11 | fairy-system 验收套件按上游维护机布局设计(`~/.local` DSH 前缀、`.dsh` 直装插件、桌面启动器/LaunchAgent 校验、版本钉 0.1.1-rc.2) | verify.js/--live 与 preflight 运行时门在本机(npm-global 前缀 + profile-link 安装)结构性不可运行 | 本机等价验收 = 5 插件测试全绿 + 真机 UI 审计 + 启动冒烟(已全部通过);fairy-system 自带测试修 URL 编码 bug 后 20/33,余 13 失败均为上述布局耦合、非本机回归 | 🔶 已按等价方案完成 |
| A12 | 未在你的真实 profile 上冒烟 | — | — | ✅ 已解决:真机 3080 两轮完整审计 |

## B. 插件行为与能力

| # | 限制(现状) | 影响 | 可能的改法 | 状态 |
|---|---|---|---|---|
| B1 | `fairy-visual` 默认 `enabled: false` | 全新安装需手动开(你已是 enabled=true) | 可改默认值 | ⬜ 低优先(仅影响全新安装) |
| B2 | browser-dock 默认无浏览器画面 | — | — | ✅ 已解决:@playwright/mcp 已装入真实 profile(msedge 适配);安装脚本默认开启,`--without-playwright` 可退 |
| B3 | 本机无 Chrome,只有 Edge | playwright 自动退化 msedge | 脚本已自动检测 | ✅ 已处理 |
| B4 | fairy-voice 依赖本地 GPT-SoVITS(9880)+ 参考音频 | 缺引擎时系统语音兜底 | — | ✅ 已解决:引擎+参考音频+LaunchAgent 自启/自愈 |
| B5 | 参考路径用 `homedir()` 忽略 DSH_HOME | 隔离环境读不到 | — | ✅ 已解决(本轮) |
| B6 | fairy-startup 强制新文档回空白会话 | 有人不喜欢 | 可改为可配置 | ⬜ 待你决定(行为偏好) |
| B7 | 汇率 1USD=¥7.2 与 V4 Flash 峰谷价写死,是估算非账单 | 价格变动会失准 | — | ✅ 已解决:pricing.json/env 覆盖(本轮) |
| B8 | 与现有 UI 生态(皮肤/侧栏/宠物等)的冲突 | 视觉打架 | — | ✅ 已解决:两轮真机审计(设置模态/皮肤贴图/侧栏/开关往返/贴图文字),0 控制台错误;装新插件后需复查 |
| B9 | fairy-visual 固定依赖 `@deepseek-ai/dsh-settings@0.1.1-rc.2`;preflight 版本门钉死 | DSH 升级后可能失效(0.1.5-rc.1 实测正常) | preflight 已支持 `DSH_APPROVED_*` env;依赖范围升级时再放宽 | 🔶 已缓解 |
| B10 | 无更新通道 | 升级靠手动 | — | ✅ 已解决:`--update`(本轮) |
| B11 | bundle 体积/本地化/无障碍/性能未评估 | 未知风险 | — | ✅ 体积已实测(见上);本地化/无障碍未动 |

## 仍需你拍板的三件事

1. **A7/A8**:是否 fork 发布 npm、是否采用仓库自带 profile 模板(涉及安全边界);
2. **B2/B6**:browser-dock 是否默认带 playwright、fairy-startup 的空白会话策略是否保留;
3. **A10**:提供 `.agent-presets/fairy` 私有资产后我补装 Fairy 人格。
