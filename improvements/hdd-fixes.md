# HDD（dsh-fairy-visual）修复记录

对象：第三方插件 dsh-fairy-visual（本地 clone，profile 用 link: 指向源码）· 你的 DSH：0.1.5-rc.1 · 你的 fairy-visual 设置：enabled=true / theme=light / mascotVisible=false

补丁留档：improvements/hdd-fixes.patch（git pull 后 git apply 复原；撤销：git checkout -- .）

## 第一轮：设置面板与对话框冲突（你报的 B8）

### 复现
隔离 DSH_HOME 镜像你的 profile（复制配置、软链你的 node_modules）+ 无头 Edge/CDP。HDD 开启时输入卡被 HDD 上了浅色卡面，从 800x800 居中设置面板的下沿/右侧露出；面板外只有 40% 不透明度遮罩 rgba(28,37,70,.4)，压不住亮色 HDD 表面。HDD 关闭时输入卡是深色半透明、融进背景，所以只有开 HDD 才出现。

### 根因
1. 上游只把 [data-slot="sidebar.settings"] [role="dialog"] 当作模态，其它模态（如 API Key 引导）完全不被识别。
2. 模态打开时上游只把 HDD 图层 z-index 压到 1，没有让 HDD 浅色表面退场。

### 改动
- dom-adapter.js：新增 modalDialog: '[role="dialog"][aria-modal="true"]' + resolver + 导出。
- semantic-markers-manager.js：nextModalOpen = settingsDialog() || modalDialog()；observer attributeFilter 增加 aria-modal / role。
- style.js：新增 modal 段 —— 模态打开时隐藏 HDD 装饰（舞台/材质层/音色与尺寸硬件）、关闭 pointer-events、清空输入卡与 input-scroll 的背景边框阴影，并 visibility:hidden 收起整条输入区。

### 证据
- 修复后设置面板右侧原亮带区域像素 159,165,179 = 与周围遮罩基底一致；无模态时输入卡正常（32-crop-hdd-nomodal.png / 33-crop-hdd-settings.png / 34-hdd-settings-full.png）。
- 通用模态用例：动态插入 role="dialog" aria-modal="true" → 标志置位且输入卡隐藏；移除后恢复（pass: true）。

## 第二轮：槽位改名兼容 + 状态条遮挡（你点名的第一条 + 截图那处遮挡）

### 复现与根因
这个 DSH 版本的会话槽位已从 [data-slot="conversation"] 改名为 [data-slot="main.conversation"]（实测 legacy=false / renamed=true）。插件全部依赖 conversation() 的能力——composer dock 全宽固定底栏、材质层、chat content anchor、HDD 覆盖式滚动条、会话头部几何、舞台几何——静默不运行（实测 [data-dsh-fairy-composer-dock] 从不出现）。
你截图里那条亮带是输入区状态条 div[data-slot="conversation.composer.dock"] 内、白色背景 rgb(255,255,255) 的节点；第一轮的规则只隐藏了输入卡，没覆盖状态条。

### 改动
- dom-adapter.js：新增 conversationAlt 选择器；conversation() 先试旧名再试新名；HDD 滚动目标用 conversationDescendant() 同时覆盖两个根；SEMANTIC_SURFACE_SELECTOR 加入新名。
- hero-projection-manager.js / index.js：表面观察与 STAGE_SURFACE_SELECTOR 同时包含两个根。
- style.js：CSS 里 3 处 [data-slot="conversation"]（含子组合器 > [data-phase] 与两处后代组合器）都补上新名别名；modal 段的隐藏集合扩展到 [data-composer-seat] 与 [data-slot="conversation.composer"]。

### 证据
- 槽位兼容生效：conversationRoots.renamed=true、seatMarked=true、dockPresent=true（dock rect x280 y813 w1232 h132 = 设计中的全宽固定底栏）、材质层与 .dsh-hdd-scrollbar-layer 均出现；无模态时 dock 正常渲染（60-slotfix-nomodal.png、65-dock-full.png）。Hero 空会话下同样正常（71-hero-with-dock.png）。
- 模态打开时：dockVis=hidden，且状态条整条链 visibility=hidden（其祖父即 [data-slot="conversation.composer.dock"]，display:none）；该区域像素 157,163,179 ≈ 遮罩基底（70-modal-with-dock.png）。

## 附带修复：上游测试自身 bug
test/capability.test.js 用 sourceRoot.pathname（URL 编码路径）配 readFileSync，路径含非 ASCII（本机 开发者/fairy deepseek开发）时必 ENOENT —— 干净 clone 上也有这 1 条失败。改为 fileURLToPath() 后，npm test 131/131 全绿。

## 你现在要做的
刷新浏览器（Cmd+R）即可看到两处修复；若 UI 未变化再重启 DSH。

## 需要你判断的一点（本轮新出现）
槽位修好后输入区变成设计中的全宽固定底栏，于是你的皮肤（blue-fantasy）右下角那只 Q 版角色会压住底栏最右侧的语音/尺寸硬件区（截图 66-dock-farright.png / 65-dock-full.png 右侧）。这是皮肤装饰与 HDD 底栏的层叠竞争，不属于槽位 bug。可选处理：把皮肤装饰在 HDD 模式下让位（改 skin 插件）、或把底栏右侧控件左移留出安全区、或干脆保留原悬浮卡形态（把 dock 投影关掉，只保留滚动条/锚点等其余能力）。你说了我再动。
## 第三轮：dock 右侧重叠 + 贴图后文字消失（你报的两条）

### 复现
镜像 profile（复制你的 settings.yaml：HDD on / light / mascotVisible false）+ 无头 Edge 1512x945，进入 dock 状态实测。

### Bug 1：右侧硬件重叠
实测（修复前）：语音胶囊 rect y 848..876，尺寸胶囊 y 862..890 → 重叠 14px。
根因：语音胶囊是绝对定位，但保留着网格放置 grid-row:2 / grid-column:3；按 CSS 规范，容器内绝对定位子元素若带网格放置属性，其**包含块变成该网格区域**（行 2 从 849 开始），而尺寸/速度胶囊的包含块是行 1 区域（从 823 开始）→ 前者整体下移 26px 造成重叠。
改法：dock 内的绝对定位硬件（语音/发送/尺寸基底与滑杆/速度基底与滑杆）统一 grid-row:auto / grid-column:auto，使其包含块回到卡片内边距盒，三者共用同一原点。
验证（修复后）：语音 812..840、尺寸基底 852..880、速度基底 892..920 —— 无重叠（测量脚本 probe-dock-right.js 的 overlaps 列表已无硬件对）；干净截图 92-rightcol-clean.png（临时隐藏皮肤贴图后拍摄）。

### Bug 2：贴图后输入文字不可见
实测：贴图后 [data-composer-input] 里文本仍在 DOM、颜色深色 rgb(23,37,49)、布局盒 474,824 133x17 均正常，但画面上看不到。
根因：附件激活时插件给卡片加了一个**不透明**基底伪元素 ::after（background rgb(247,250,252) + 基底渐变，left 180px / top 10px / 872x178，z-index 1），它本该在文字**下面**；但卡片规则 `>:not([data-dsh-fairy-composer-material]){z-index:1}` 把 [data-input-scroll] 从 z-index 2 压回 1，::after 作为最后绘制的同级元素盖住了文字。占位符阶段看不出来，一旦有真实文字（贴图后视口计算变化）就暴露 —— 与你的现象一致。
改法：附件激活时强制 [data-input-scroll]{position:relative;z-index:2}，把输入层抬回基底之上（基底几何不变，仍是输入口的底漆）。
验证（修复后）：[data-input-scroll] 计算 z-index=2，::after 仍为 z-index 1 且几何不变；截图 90-inputline-after-fix.png 中文字清晰可见（"贴图后文字应可见 XYZ"）。

### 测试
npm test 131/131 通过（CSS 金标 136958 字节 / sha256 bc1c1a5a... 已同步）。

### 仍未处理（等你拍板）
皮肤贴图遮挡：实测皮肤装饰节点 `img.dshwv-img`（149x149，absolute，pointer-events:none，位于 1363,796）正好压在 dock 右侧硬件区（x 1360..1512）之上，因此硬件胶囊在视觉上被角色挡住（截图 91-rightcolumn-after-fix.png）。这不属于插件 bug，是皮肤装饰与 dock 的层叠竞争。可选：①皮肤加 HDD 模式让位规则；②硬件区左移留安全区；③把 dock 投影撤掉只保留其余能力。

## 第四轮：dock 组件重新排版（你说「位置很不好」）

### 问题
三件硬件（语音波形+音量、眼睛尺寸、动画速度）挤在 dock 最右下角：x 1348..1512，正好落在皮肤贴图 img.dshwv-img(1363..1512 x 796..945) 上面，且与发送键同处一栏，视觉很挤。

### 新排版
给 dock 卡片加一条**专用硬件栏**（网格第 3 列 168px）+ **皮肤安全区**（第 4 列 172px，留空），输入卡自动收窄；三件硬件改成同一竖栏、同宽度、同右边界、6px 等距堆叠；发送键回到输入卡右下角、硬件栏左侧。
- 卡片网格：minmax(176px,max-content) | minmax(0,1fr) | 168px | 172px
- 硬件栏：left:auto right:180px width:152px（x 1180..1332）；top 依次 4 / 38 / 72px（y 817..845 / 851..879 / 885..913）
- 发送键：left:auto right:364px（x 1120..1148，落在输入卡右下角内）
- 硬件三件 + 发送键都做了 grid-row/column:auto 复位，保证与卡片共用同一包含块（否则语音胶囊会以网格第 2 行区域为基准而错位 26px）
- ≤1200px 视口：退回三列布局并隐藏硬件栏（窄屏优先保证输入宽度），发送键回到右端 12px

### 验证（镜像 1512x945 实测）
| 元素 | rect |
| --- | --- |
| dock | 280,813 1232x132 |
| 输入卡 | 460,849 696x86（右边界 1156） |
| 发送 | 1120,909 28x28 |
| 语音 | 1180,817 152x28 |
| 眼睛尺寸 | 1180,851 152x28 |
| 动画速度 | 1180,885 152x28 |
| 皮肤贴图 | 1363,796 149x149 |
重叠检测：硬件三件之间、硬件与输入、硬件与皮肤、硬件与发送 —— 全部无重叠（仅剩 dock 内含关系与发送键叠在输入卡右下角，均为设计内）。
截图：95-relayout-full.png（整屏）、96-relayout-dock.png（dock 全宽）、97-relayout-rail.png（硬件栏 2 倍放大）。

npm test 131/131 通过（CSS 金标 138046 字节 / sha256 290585ac...）。

## 第五轮：按你的要求撤掉 HDD 输入区投影，对话框回到官方形态

### 改动
- constants.js 新增开关 `export const COMPOSER_DOCK_ENABLED = false;`（含注释说明：该 DSH 布局把工作区控件放在输入卡 accessory 行、官方 dock 槽位保持隐藏，投影会把这版输入区变形，因此保留官方输入区）。
- index.js 的 stage-host 挂载改为 `if (COMPOSER_DOCK_ENABLED) lifecycle.add(mountComposerDock(controller), ...)`，dock 代码整块保留，供布局契约匹配的版本启用。
- 上一轮为 dock 写的硬件竖栏/网格列 CSS 全部以 `[data-dsh-fairy-composer-dock="true"]` 为前缀，dock 不挂载时自然失效（保留在源码里，重新打开开关即恢复）。

### 保留的 HDD 能力（未回退）
槽位兼容带来的：HDD 覆盖式滚动条 `.dsh-hdd-scrollbar-layer`、会话历史面板切面 `[data-dsh-fairy-history-surface]`、会话头部几何 `[data-dsh-fairy-header-utilities-cluster]`、侧栏板件、品牌标；以及第 1~2 轮的模态退场规则。

### 验证（镜像 1512x945）
| 检查项 | 结果 |
| --- | --- |
| `[data-dsh-fairy-composer-dock]` | 不存在（投影未挂载） |
| 材质层 / 右侧硬件三件 | 全部不存在 |
| 输入卡 rect | 485,809 820x98（官方居中卡，radius 22px、display flex、grid-template-columns none） |
| input-scroll rect | 485,817 816x36 |
| HDD 滚动条层 / 历史面板 / 头部几何 / 侧栏 / 品牌标 | 均存在 ✓ |
| 设置面板打开时 | 输入卡与 composer 槽位 `visibility:hidden`（模态退场仍生效） |
截图：100-native-composer.png（整屏）、101-native-dock-band.png（输入带）、102-native-modal.png（模态打开）。

npm test 131/131 通过（本轮未改 CSS，金标不变 138046 字节 / sha256 290585ac...）。

## 第六轮（2026-09-18，ZCode 会话）：全面审计后的三处体验修复 + Fairy 本音引擎恢复

对镜像 + 真机（127.0.0.1:3080）做了一次全面审计：B8 模态退场、槽位兼容、滚动条层、历史面板、H.D.D 开关往返、贴图文字层级——前五轮的修复全部仍然生效，切换全程 0 控制台错误。审计发现三处新问题，已修复：

### 1. HDD 夜间模式：hero「预览版」徽章白字白底不可读
- 实测：徽章文字 `rgba(232,242,250,.7)`（亮白），背景 `rgb(220,227,247)`（浅紫白），对比度约 1.3:1。根因：HDD 暗色把别名标签变量翻成亮色，但徽章底色是 DSH 自己硬编码的浅色，不随变量翻转。
- 改法（`src/client/style.js` 新增 themes 段）：`html[data-dsh-fairy-visual][data-dsh-fairy-theme="dark"] [class*="previewBadge"]` 给深蓝半透底 `color-mix(in srgb,#62d4ff 14%,rgba(8,20,34,.72))` + 浅青文字 `#a8dcf5` + 内嵌 1px 青描边（用 inset ring 不用 border，几何零位移）。仅暗色生效，日间保持 DSH 原样。
- 验证：夜间下徽章清晰可读（verify-02-badge-zoom.png），日间样式不变。

### 2. 设置面板 HDD 分区：裸复选框 + 原生 `<select>` 与面板风格脱节
- 改法：Settings 容器加 `.dsh-fairy-settings`、身份选择行加 `.dsh-fairy-settings-row`；style.js 新增 `settings` 段——行改为 flex 行布局（13px、hover 高亮、圆角），复选框 15px + 品牌色 accent，`<select>`/文本输入统一 30px 高、8px 圆角、别名边框/底色、focus 品牌色描边。颜色全部走别名变量，日/夜主题自适配。
- 验证：夜间/日间截图（verify-04-settings.png / real-verify-settings.png）中控件与面板融为一体。

### 3. fairy-voice 自动朗读开关：无图标灰方块（状态点 0×0）
- 根因：`.dsh-fairy-voice-auto-dot` 这个 span 在注入样式表里**没有任何 CSS 规则**（尺寸缺失），开关只剩 `data-on` 的灰色底 = 无名灰方块，看不出是什么、也看不出开/关。
- 改法（`fairy-voice/lib/client.js`）：dot span 换成内联 SVG 循环箭头图标（16×16、stroke currentColor，自包含不新增依赖）；补 `.dsh-fairy-voice-auto svg{display:block;16×16}`。on 态配色**保持上游契约**的克制语义（`label-secondary` 12% 底，client-contract 测试锁定），靠图标本身表达状态。
- 验证：镜像/真机胶囊中 ▶ + 循环图标 + 音量滑杆清晰可辨（verify-03-voice-pill.png / real-verify-pill.png）。

### 4. Fairy 本音引擎恢复（运维）
- 审计时发现 GPT-SoVITS 引擎（9880）没在运行——重启电脑后不会自动拉起，此前语音一直在走系统语音兜底。
- 已用 `fairy-dev-tools/start-voice-engine.sh` 重新拉起；真机 `GET /fairy-voice/status` → `{"available":true,"backend":"gpt-sovits","voice":"Fairy","referenceInstalled":true}`；`POST /fairy-voice/tts` → http 200、`X-Fairy-Voice: fairy`、TTFB 0.58s、1.48s 非静音音频（峰值 0.406）。
- 注意：引擎随本会话 nohup 存活，** Mac 重启后需要重跑一次 `bash fairy-dev-tools/start-voice-engine.sh`**（想要开机自启可以再做 LaunchAgent，等你拍板）。

### 5. GPT-SoVITS 开机自启 LaunchAgent（同日追加，已实测）
- 安装 `~/Library/LaunchAgents/com.fairy-dsh.gpt-sovits-engine.plist`：RunAtLoad（登录自启）+ KeepAlive.SuccessfulExit=false（崩溃自动拉起，端口被占时干净退出 0 防循环）+ ThrottleInterval 30s + Background/Nice 5。
- **关键坑**：launchd 拉起的进程没有「桌面文件夹」TCC 权限，引擎放 Desktop 下时脚本直接 EPERM（exit 126）。处理：引擎实体整体 `mv` 到 `~/Library/Application Support/fairy-tts/`（同卷重命名，瞬时；含 GPT-SoVITS、venv、模型、home 缓存），`fairy-dev-tools/tts` 留软链指过去，旧脚本全部照常可用；LaunchAgent 入口脚本为 `fairy-tts/voice-engine-launchd.sh`（`exec` 前台运行，launchd 直接持有 PID）。
- 实测：加载即起（热缓存 ~8s，冷启动 30–60s）；`kill -9` 后 **24s 自动复活**（新 pid、PPID=1）；真机 `/fairy-voice/status` → `backend:gpt-sovits`，TTS 合成 `X-Fairy-Voice: fairy`、2.66s 非静音音频 ✓。
- 运维入口：`launchctl print gui/$(id -u)/com.fairy-dsh.gpt-sovits-engine` 看状态；`launchctl kick -k gui/$(id -u)/com.fairy-dsh.gpt-sovits-engine` 重启引擎；日志在 `fairy-tts/launchd.log`；卸载 `launchctl bootout gui/$(id -u)/com.fairy-dsh.gpt-sovits-engine && rm ~/Library/LaunchAgents/com.fairy-dsh.gpt-sovits-engine.plist`。

### 生效方式与回归
- 实测确认：DSH 宿主每次页面加载按磁盘内容重新计算 bundle rev——**源码重建后刷新页面（Cmd+R）即生效，无需重启 DSH**。
- fairy-visual `pnpm bundle` 重建；CSS 金标更新为 139574 字节 / sha256 37a896ca...；`npm test` 131/131 ✓。fairy-voice `npm test` 58/58 ✓。
- 补丁已重新生成：`improvements/hdd-fixes.patch`（fairy-visual 全部未提交改动，含 1~6 轮）、`improvements/fairy-voice-fix.patch`（fairy-voice 全部未提交改动 + system-tts 新文件，含语音轮 + 本轮）。
- 顺带清理：`fairy-voice/dsh-fairy-voice/-f`（上轮测试误写出的 WAV 残留）已删除。

## 第七轮(2026-09-18,LIMITATIONS 逐条清账)

对照 LIMITATIONS.md 的 A1–A12 / B1–B11 两张表逐条复核并处理:

- **B5 收尾**:fairy-voice 的 `voice-brain.json` 路径还残留 `homedir()` 硬编码(主路径早已尊重 DSH_HOME),已统一走 `FAIRY_HOME`。58/58 ✓。
- **B7**:balance-meter 汇率/价目可配置化——`$DSH_HOME/balance-meter/pricing.json`(逐字段覆盖,非法值回退默认)+ 环境变量 `DSH_FAIRY_USD_CNY`;默认行为逐字节不变(契约测试全绿)。10/10 ✓(新增 1 条覆盖行为测试)。
- **A6**:`install-fairy-to-dsh.sh --uninstall`——精确移除装配块/本仓库 link 依赖/node_modules 链接并刷新 lockfile,幂等;**踩坑重修**:非 UTF-8 locale 下 heredoc 里 `$VAR` 后跟中文全角逗号会被 bash 当变量名字节(set -u 报 unbound),与上轮 locale 坑同类,已用 `${VAR}` 修复。临时 profile 实测含幂等重跑 ✓。
- **B10**:`--update`——git pull(--ff-only,本地有改动则安全跳过)→ 依赖刷新 → browser-dock/fairy-visual bundle 重建 → 三插件回归测试 → 装配校验。临时 profile 实测 ✓。
- **A11 补完**:5 个插件测试套件全绿(bm 10 / bd 11 / fv 131 / fvoice 58)+ fairy-system 自带测试 20/33——修掉 2 处 URL 编码路径 bug(中文路径必 ENOENT)后从 18→20;余 13 个失败全部为上游维护机布局耦合(~/.local 前缀、.dsh 直装、版本钉 0.1.1-rc.2、桌面启动器/LaunchAgent 校验),属结构性不可运行而非回归,已如实记录。check.sh 对缺失私有资产改为按存在性跳过;preflight-build.js 新增 `DSH_APPROVED_DSH_VERSION`+`DSH_APPROVED_RUNTIME_SHA256` 成对 env 覆盖(缺一不生效)。
- **B11**:体积实测——5 插件 client bundle 合计 ≈590KB raw / ≈120KB gzip,大头是 fairy-visual(461KB raw / 85KB gzip,含全部 CSS 与吉祥物 SVG 代码);合并单请求加载,首载后走缓存。
- **B4 补充**:GPT-SoVITS LaunchAgent 开机自启 + 崩溃自愈(详见上文第 5 节)。
- **注意**:本轮 B5/B7 属宿主侧代码,下次 DSH 重启后加载;两者默认行为与现状完全一致,不配置覆盖即无差异,无需专门重启。
- 留档:`improvements/system-fixes.patch`(balance-meter + fairy-system 本轮改动)、`hdd-fixes.patch`/`fairy-voice-fix.patch` 已重新生成。

## 第八轮(2026-09-18 晚,按你的三个决定执行)

1. **A7(fork+发布)备妥**:本机无 npm 登录态/gh CLI,产出 `improvements/npm-publish/`——
   `prepare-npm-packages.sh` 把 6 个包(contracts+5 插件)staging 成可发布形态(去 private、
   `@deepseek-ai/*` 宿主私有依赖转 peerDependencies、link 依赖改写 registry 版本、files 白名单),
   `PUBLISH.md` 含 npm 发布与 GitHub fork 的精确命令。你登录后即可发。
2. **A8(采纳模板)**:先备份(`.fairy-install-backup/pre-template-20260918/`),然后合并——
   安全三件套(sandbox danger-full-access / approval never / permission 默认)、context7 MCP、
   dsh-reasoning-effort(github 钉版本)+ pnpm v12 格式补丁接线(注意:pnpm 12 不再读
   package.json 的 pnpm.patchedDependencies,要写进 pnpm-workspace.yaml)。
   **必要偏差**:模板的 `dsh-message-edit` bundle 在 DSH 0.1.5-rc.1 上构建期 externals 漂移
   (require @deepseek-ai/dsh-client-runtime/client 不在模块表),实测弹出"Failed to load
   plugins"横幅,已从 bundles/deps/补丁中摘除并留档——这是模板与这版 DSH 的版本耦合,非安装错误。
3. **B2**:playwright 默认开启(脚本默认值翻转,新增 `--without-playwright`),`@playwright/mcp@0.0.79`
   已装入真实 profile,MCP 块按本机实际自动选 msedge。
4. **A10(你判断正确——不是私有财产)**:git 历史核查证明人格内容资产(性格/世界观/圣典/行为/文风)
   全部在初始公开提交里、工作区一直都有;真缺的只有 `runtime/` 与 `world-core/`。按公开契约重建:
   - `fairy_core.py`:校验+确定性编译声音片段(行为策略/句感底线/语域与校准样例/世界认知边界),
     离线资产硬排除,fail-closed,字节预算截断;Python 测试 18 项全过。
   - `index.js`/`compiler.js`/`safety-gate.js`/`world-knowledge.js`:cordis 模块与桥(契约对照
     liangshen 预设学习),Node 测试 7/7。
   - **实测发现:DSH 预设扫描跳过软链目录**——必须真实目录。已物化安装到
     `~/.dsh/.agent-presets/fairy` 并在镜像验证预设列表出现"Fairy";留 `sync-fairy-preset.sh`。
   - `world-core` 游戏语料确缺:检索如实降级(反事实圣典禁止编造);owner 提供语料后自动启用。
   - `agent.cordis.yml` 的 `DSH_FAIRY_REPO_ROOT` 引用加了本机绝对路径兜底(env 优先)。
5. **镜像全程验证**:模板合并+预设安装后的完整配置在隔离实例启动零错误、UI 无横幅、Fairy 预设可见。

**生效方式**:预设/MCP/补丁/模板都是启动时加载——**重启 DSH 一次**全部生效;之后在
设置 → Agent 预设 里选"Fairy"即可换人格。

## 第九轮(2026-09-18 深夜):预设挂载修复 + world-core 语料自研

### 1. 「预设显示加载失败」根因与修复
- 真实 UI 的预设卡片标记 `cardBroken`,错误文本:`row 2 names no plugin (a "name" string is required)`。
- 根因:上游 agent.cordis.yml 用 `!!js process.env.DSH_FAIRY_REPO_ROOT + '/...'` 绝对路径表达式引用 runtime 模块;这版 DSH 的预设装载器只认**插件包名或 `./相对路径`**(对照 liangshen 预设:`name: ./minimal-prompt.mjs`)。
- 修复:三个引用全部改为预设相对路径(`./runtime/index.js`、`./runtime/safety-gate.js`、runtimePath → `./runtime/fairy_core.py`)。
- 镜像实测:cardBroken 消失 → **实际切换到 Fairy 预设成功,activePreset=Fairy,零错误**。
- 注意:真实 DSH 实例当时尚未重启(仍是旧进程),所以用户看到的是旧扫描结果;文件已修好并同步,重启后重新选择即可。

### 2. world-core 语料(用户授权自研)
- 核查确认:人格内容资产全部公开(用户判断正确),world-core 游戏语料从未发布;经 4 轮定向检索(萌娘百科/百度百科/官方资料/知乎解析)后自研 48 条:
  - characters.jsonl 13 条(Fairy/哲/铃/伊埃斯/仪玄/仪绛/橘福福/朱鸢/青衣/赛斯/艾莲/丽娜/梅弗劳尔)
  - concepts.jsonl 19 条(空洞/以太/绳网/HDD/绳匠/盗洞客/法厄同/零号空洞/虚狩/始主/卫非地等)
  - factions.jsonl 16 条(四大智能构造体及 Youkai/Ghost/Jinni 各条/HIA/H.A.N.D/治安局/刑侦特勤组/维多利亚家政/云岿山/TOPS/坎卜斯黑枝等)
- 置信分布:high 33 / medium 13 / low 2(朽峰、辉瓷仅被提及,如实标 low);全部自己的话概述,不复述大段原文;Ghost/Jinni 未确认属性如实写"尚未正式确认";与 canon/anti_fanon 零冲突(主人称呼频率、无证据概率、过度亲昵三条漂移风险均未触碰)。
- 验证:`fairy_core.py validate` → worldCore.available=true;lookup('Fairy'/'哲'/'空洞'/'TOPS'/'仪玄') 全部命中;Python 18 项 + Node 7/7 全绿(world-knowledge 的语料在场分支实际执行)。
- 已同步到 `~/.dsh/.agent-presets/fairy`。

### 3. 第二次切换报错:persona 字段漂移(同晚修复)
- 你重启后切换报:`failed to apply loader entry persona (@deepseek-ai/dsh-persona): invalid config: $.prefix missing required value`。
- 根因:上游 composition 为 DSH 0.1.1-rc.2 写的 `config.text`,这版 DSH 的 dsh-persona 必填字段叫 **`prefix`**(对照本机正常工作的 liangshen 预设即可确认)。
- 修复:persona 的 `text:` 改为 `prefix:`(一行),同步 ~/.dsh。
- 镜像实测:切换零报错,预设列表「当前使用」落在 Fairy 上,输入区模式选择器显示 Fairy——正向确认挂载成功。
- 由于组合在**切换时**才解析,你大概率不用再重启:直接再点一次 Fairy 即可;若仍报错则重启 DSH 后再选。

## 第十轮(2026-09-19 凌晨):语音播放反复失败的根因与修复

### 现象
昨晚 17:55–18:02 连续出现 `tts.stream failure: local-service-failed` 且 `headers_sent=true`(音频已开始播,中途断流);用户体感"老是播放失败"。

### 根因(引擎侧 54 次相同崩溃栈)
GPT-SoVITS 的中英混合文本前端需要 NLTK 英文词性标注器,而 **`averaged_perceptron_tagger_eng` 数据包缺失**(nltk 3.9+ 把它从 `averaged_perceptron_tagger` 拆分出来单独分发)→ 凡是含英文片段的回答(技术回答里的 DeepSeek、tok/s、HDD、文件名……)在流式合成中途 `LookupError` 崩溃 → 宿主代理发现上游流断开,报 local-service-failed。**纯中文短句不受影响**——这正是此前所有验证测试(全是短中文)都通过、没暴露此问题的原因。

### 修复
下载缺失的 NLTK 数据到引擎 HOME(`~/Library/Application Support/fairy-tts/home/nltk_data/`):
`averaged_perceptron_tagger_eng`、`averaged_perceptron_tagger`、`punkt`、`punkt_tab`。
无需重启引擎(nltk 在每次请求时查找数据,实测立即生效)。

### 验证
- 引擎直打(代理同参数,cut5/streaming):中英混合句 → http 200,12.6s 非静音音频(峰值 0.692),墙钟 14.2s。
- 真实实例端到端 `/fairy-voice/tts`:英文重混合句 → http 200,`X-Fairy-Voice: fairy`,14.7s 非静音音频(峰值 0.577)。
- 引擎日志修复后零新错误。

### 备注
- CPU 合成接近实时(长句要等合成),如需更快可再评估 MPS/GPU 路线(上一轮会话曾因 torch/codec 兼容问题搁置)。
- 自动朗读(voice-brain)的状态播报与答案朗读走同一 TTS 链路,一并修复。

## 第十一轮(2026-09-19):语音引擎稳定性与速度改善

### 诊断结论
"不稳定" = 昨晚的 NLTK 崩溃(已修,第 10 轮)+ CPU 合成慢(RTF 1.6–2.6x)+ 冷启动。引擎本身在 LaunchAgent 下运行稳定(唯一历史错误即 NLTK)。

### 实验与数据(中句 10s 音频基准)
| 方案 | RTF | 结论 |
|---|---|---|
| CPU batch1 串行(原配置) | 1.76x | 基线 |
| **CPU batch4** | **1.14x** | **采纳:全链路实测 ~1.3x,提速约 28%** |
| CPU batch2 | 1.23x | 次优 |
| CPU parallel_infer | 1.81x | 无收益 |
| CPU batch4+parallel | 2.24x | 更差 |
| MPS(torch 2.5.1) | 4.9–34x | **否决:大量算子回退,慢 12 倍**;配置已回退 CPU 并留备份(tts_infer.yaml.cpu-bak) |

### 改动
1. `local-tts-proxy.js`:`batch_size` 1→4(宿主侧,重启 DSH 生效)。
2. `lib/index.js` TTS 处理器:引擎请求失败(探测零字节)时**单次重试**(300ms 间隔,abort/supersede 不重试),重试仍失败才走系统语音兜底——瞬时抖动不再直接降级成系统音色。
3. 测试 58/58 绿;镜像实例(补参考音频)全链路实测:热机 RTF ≈1.3x,`X-Fairy-Voice: fairy` 正常。

### 后续可选(未实施,等你拍板)
- 引擎看门狗:定时探活,挂死自动 kickstart(防未来未知原因的挂起)。
- 参考音频升级:现用 5.16s 参考偏短,换 8–10s 更干净的参考通常更稳(上轮会话还有 b/c 两个候选)。
- 更换引擎(CosyVoice/index-tts 等):质量与速度大改,工作量大。
- 每日定时重启引擎:防长跑内存碎片。

## 第十二轮(2026-09-19):Fairy 音色微调——9 段语料训练专属模型

### 动机
单条 5.16s 参考音频的零样本克隆音色不稳定。用户授权用更多片段训练。

### 数据与管线
- 重新下载源视频音频(BV1KQa3eSE4V,72s),按静音边界密集切片 → **9 段 45.6s** 干净语音,响度归一(-18 LUFS)。
- SenseVoice 批量转写(模型缓存重建下载)→ 9 条文本,台词特征完整("主人,我等待着您从洗手间王者归来")。
- 无头复刻 GPT-SoVITS webui 开放数据集管线(fairy-dev-tools/train-fairy.sh,六步):
  list→文本分词→hubert/32k→语义 token→SoVITS 微调→GPT 微调。
  踩平的坑:PYTHONPATH 需含仓库根+GPT_SoVITS 两层(text 包在包内);预处理分片文件需
  cat 合并(2-name2text/6-name2semantic);训练依赖补装(gradio/pytorch_lightning/tensorboard,
  清华镜像;huggingface-hub 回钉 <1.0 保 transformers 兼容);logs_s2_v2/SoVITS_weights_v2
  目录需预创建;list 必须绝对路径;6-name2semantic-0.tsv 空文件会短路语义提取(存在即跳过)。

### 结果
- SoVITS 微调 8 epoch(权重 e4_s200→e8_s400.pth),GPT(AR)微调 4 epoch(e1-e4.ckpt,
  top3 准确率 1.0——小数据快速拟合属预期)。
- 引擎已切至微调权重(tts_infer.yaml:t2s→fairy-zh-e4.ckpt,vits→fairy-zh_e8_s400.pth),
  重启后加载正常(enc_q 缺键为 SoVITS 推理正常现象)。
- 端到端合成验证:200,X-Fairy-Voice: fairy,6.62s 音频(峰值 0.693)。
- 试听:improvements/fairy-reference/fairy-finetuned-test.wav(对比旧版 fairy-voice-final.wav)。

### 回滚
`tts_infer.yaml.cpu-bak` 保存预训练权重版配置;恢复后 kickstart 引擎即回旧音色。

## 第十三轮(2026-09-20):Fairy 套件总开关——解决与其它插件的布局冲突

### 需求
皮肤/侧栏等其它插件与 Fairy 布局冲突,需要**随时开关整套 Fairy 套件**,不想反复装卸。

### 设计
把现有 H.D.D 开关升级为**套件总开关**——单点状态 = `<html data-dsh-fairy-suite>` 属性,
由 fairy-visual 的 syncDocumentMode/dispose 随 `enabled` 同步维护(视觉/语音本就随它开关)。

新增门控(全部客户端逻辑,页面刷新即生效):
| 插件 | 挂载点 | 闸门行为 |
|---|---|---|
| balance-meter | sidebar.footer.action 槽位 | FairyGatedMeter:MutationObserver 观察 suite 属性,关→null 实时退场,开→恢复 |
| browser-dock | shell.overlay 槽位 | 同模式 FairyGatedDock(实时) |
| fairy-startup | 每次页面加载的清会话 | 装载时检查 suite 属性,套件关闭则跳过(恢复原生会话恢复) |
| fairy-visual | 本体 | H.D.D 开关即总开关;设置区标签改「启用 Fairy 套件」 |

命名注意:用独立的 `data-dsh-fairy-suite` 而非复用 visual 属性——fairy-system 契约测试
禁止 startup 客户端源码含 "fairy-visual" 字样;startup 测试桩同步补上该属性。

### 验证
- 测试:fairy-visual 131/131、browser-dock 11/11、balance-meter 10/10、fairy-startup 3/3 ✓
- **真实实例实测开关周期**:开→余额卡在场/主题全开;点 H.D.D→余额卡实时消失、主题卸下;
  再开→余额卡实时恢复 ✓(MutationObserver 生效,无需刷新)
- 无控制台错误;所有改动均为客户端 bundle + live 属性,无需重启 DSH。

### 使用
- 开关:右上角 H.D.D 胶囊(悬停提示「Fairy 套件总开关」)或 设置→HDD 视觉与 Fairy 身份→
  「启用 Fairy 套件」复选框。与其它冲突插件共用时:关 H.D.D → 用你的皮肤/侧栏布局;
  需要时再开。
- 注意:fairy-startup 的空白会话策略随开关在**下次页面加载**时切换。

## 第十四轮(2026-10-03):DSH 0.2.0 + 桌面端适配

### 环境变化
- CLI 升级 0.2.0-rc.2;新增桌面端(DeepSeek Harness.app,Electron),使用**独立 profile "desktop"**。
- 0.2.0 把 settings.yaml 迁移为 `settings.yaml.imported` + 新内部存储;**webUiSettings/settingsScope
  客户端 API 与 @deepseek-ai/dsh-settings 的 settingsNamespace 导出全部移除**。
- desktop profile 被 CLI 锁定("managed exclusively by the Electron application"),
  dump-config/plugin add/install 全部拒绝——但 profile 本体仍是标准 patch 层。

### 修复:Fairy 套件设置移植到自有存储(B9 兼容问题的最终解)
- 根因:fairy-visual 的开关写入走 webUiSettings→host settings(0.1.x API),0.2.0 上**静默失效**
  (无报错、无持久化);且旧 src/index.js 顶层 `import { settingsNamespace }` 会直接炸掉宿主模块。
- 改法:宿主注册自有路由 `/fairy-visual/settings`(GET/POST,webServer 契约同 fairy-voice),
  存储于 `~/.dsh/fairy-visual/settings.json`(原子写、0600、尊重 DSH_HOME→镜像隔离);
  首次访问自动从 `settings.yaml.imported` 种子迁移(fairy-visual + fairy-identity 两个块,极简块解析)。
  客户端 Controller 换成 createLocalSettingsBridge(同 getSnapshot/subscribe/set 接口),UI 组件零改动;
  web 与桌面端共享同一存储(FAIRY_HOME 级)。
- 代价:0.1.x 的 schemastery 设置面板注册(`settings.register`)不再使用——设置面板分区在新版是否
  渲染取决于宿主 settings.section 槽位(仍为客户端槽位,组件保留);主交互走 H.D.D 胶囊开关。

### desktop profile 接线
- 直改 `profiles/desktop/{package.json,cordis.patch.yml}` + `pnpm install`(绕过 CLI 锁;
  5 个 link 依赖 + 装配块就位)。Electron 重启后生效;若应用回写文件则需改走应用内插件市场(包已备好)。

### 验证(隔离镜像,0.2.0-rc.2)
- 宿主:fairy-voice status ✓;视觉/语音/余额/启动四个客户端 bundle 全部加载,零控制台错误。
- 开关状态机:点击 → POST → settings.json 落盘 → suite 属性联动 → 再点击回写 ✓(镜像 home 的
  种子默认 enabled=false,故探针首态为关;真实实例将从 legacy 种子为开)。
- 测试:fairy-visual 132/132(新增存储回环/legacy 种子测试)、voice 58、balance 10、dock 11、startup 3 ✓。

### 用户操作
1. Web 端:刷新页面即用新设置后端(H.D.D 开关、主题、余额卡、语音全恢复,偏好从旧设置种子迁移)。
2. 桌面端:**重启 DeepSeek Harness 应用** → desktop profile 载入 Fairy 五插件;若未出现,
   反馈给我(则桌面端走插件市场发布路线,包已在 improvements/npm-publish/)。
3. Fairy 人格预设与语音引擎不受影响(共享 home 与 LaunchAgent)。
