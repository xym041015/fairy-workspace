# fairy-voice 修复记录

对象：dsh-fairy-voice（本地 clone，profile 用 link: 指向源码）· DSH 0.1.5-rc.1 · macOS · 补丁：improvements/fairy-voice-fix.patch

## 诊断（实测）
1. `~/.dsh/fairy-voice/` 只有 `voice-brain.json`，**没有** `runtime/reference/fairy_ref.wav|txt` → 启动时插件打一条 `reference.prompt.load` warn 并回退提示词（这条本身无害）。
2. 本机 **9880 端口无服务**（9880/9881/7860/8000 全 down）→ 插件唯一后端 GPT-SoVITS 不可用。
3. 于是 `GET /fairy-voice/status` 返回 `{available:false, reason:'本地 Fairy 服务未启动。'}`，客户端据此把朗读控制置为不可用；即使强行朗读，`POST /fairy-voice/tts` 也会因为取不到上游音频而失败。

结论：不是代码 bug，而是**缺少本地语音后端**（GPT-SoVITS + 参考音频需要额外下载数 GB 模型）。

## 修复：新增 macOS 系统语音兜底后端
新文件 `lib/server/system-tts.js`：用系统 `say` 合成，产出与客户端契约**完全一致**的裸 PCM（32000 Hz / 16-bit / 单声道），必要时用 `afconvert` 转格式；失败/不支持时抛 `local-service-unavailable`/`local-service-failed`。
- 音色选择：`DSH_FAIRY_TTS_VOICE` 环境变量优先；否则从 `say -v '?'` 里按 zh_CN（Tingting/Flo/Grandma/Eddy…）→ zh_TW（Meijia）→ zh_HK（Sinji）挑一个中文音色。语速可用 `DSH_FAIRY_TTS_RATE` 指定。
- `lib/index.js` 接线：`/fairy-voice/status` 先问 GPT-SoVITS，失败则报系统语音可用；`/fairy-voice/tts` 先走 GPT-SoVITS 流式，遇到 `local-service-unavailable|local-service-failed|timeout` 自动改用系统语音并打一条 `tts.stream.fallback` 指标。
- GPT-SoVITS 一旦在本机跑起来（9880 就绪），仍优先使用它 —— 也就是 Fairy 本音；系统语音只是兜底。

## 验证
| 项目 | 结果 |
| --- | --- |
| `GET /fairy-voice/status`（镜像真机） | `{available:true, reason:null, backend:'system-voice', voice:'Tingting (中文（中国大陆）)'}` |
| `POST /fairy-voice/tts`（真机） | HTTP 200 · `content-type: audio/raw` · 204952 字节 |
| PCM 校验 | 102476 采样 = **3.20 秒** @32kHz，峰值 0.606、RMS 0.1228（非静音） |
| 浏览器端到端 | 点击「Fairy 朗读控制」（原生输入区内，rect 711,870 104x28）后，主机日志出现 `tts.stream.fallback` + `tts.stream` 指标 |
| 单测 | `test/system-tts.test.js` 新增 3 例（音色选择 / 只接受 32k 单声道 16bit 契约 / 不支持格式时转码）；fairy-voice `npm test` **58/58** 通过 |

## 用法与后续
- 现在：朗读控制直接可用，音色是系统中文语音（Tingting）。想换：`DSH_FAIRY_TTS_VOICE="Meijia"`（或任何 `say -v '?'` 里的名字）；想调语速：`DSH_FAIRY_TTS_RATE=180`。
- 想要 **Fairy 本音**：仍需自备 GPT-SoVITS 服务（127.0.0.1:9880）与参考音频 `~/.dsh/fairy-voice/runtime/reference/fairy_ref.wav` + `fairy_ref.txt`；服务一旦就绪会自动优先使用，无需改代码。
- 未处理的小项：插件用 `homedir()` 拼 `~/.dsh/fairy-voice/...`（忽略 `DSH_HOME`），你的环境是默认 DSH_HOME 所以不受影响；启动时那条 `reference.prompt.load` warn 在没放参考音频时会一直在（提示词已回退，功能不受影响）。
## 追加：为什么「朗读没有声音」

### 诊断（真机 + 浏览器 Web Audio 打桩实测）
1. **那个按钮不是「立即朗读」**：输入区的 `[data-dsh-fairy-voice-control]` 组里，`dsh-fairy-voice-auto` 只是**自动朗读开关**，音量滑杆是 `dsh-fairy-voice-volume`。自动播报的触发条件是「一轮回答闭合后」`currentTurnFinals` + 900ms 结算，且需要 `autoRead && audioReady && available`。点开关只是切换自动播报，不会读现有内容 → 点了没反应很正常。
2. **可用性**：在上一轮修复之前 `available=false`（本机没有 GPT-SoVITS），自动播报策略恒为假 → 从来不会出声。
3. **音量**：音量存在 localStorage `dsh.fairyVoice.volume`，滑杆就在开关右边（我测试时都误点到过，值被写成 0.25）→ 值为 0/极低时播放但听不见。
4. **音频上下文**：`AudioContext` 必须在**用户手势**里 `resume()`；自动播报发生在回答结束后（非手势），只有此前已被手势解锁过才会出声。实测上下文停在 `suspended` 时，音频被排布了却听不到。
5. 播放链路本身没问题（实测）：手动投递 `fairy-voice-play` 后，浏览器创建 32kHz 上下文并排布了 **5.54 秒** PCM 缓冲；主机侧 `/fairy-voice/prepare` + `/fairy-voice/tts` 正常。

### 客户端修复（lib/client.js）
在控制组里新增**「朗读当前回答」按钮**（`[data-dsh-fairy-play-control]`，图标按钮，位于开关左侧）：
- 点击即：在手势里 `primeAudio()` 解锁/恢复音频上下文 → 音量 ≤0.05 时自动拉到 1（同时写回 localStorage 与增益）→ 取时间线上**最新一条已结算回答**（`snapshot.messagesById`）→ 按既有 `fairy-voice-play` 契约投递 `{ messageId, markdown, sessionKey }` 立即朗读；播放中再点即停止。
- 自动朗读开关与音量滑杆保持原语义不变（自动播报新回答仍默认开启）。
- 失败不静默：`primeAudio` 失败走 `reportAudioLifecycleFailure('prime', ...)`（仓库契约测试要求无静默 catch）。

### 测试与验证
- fairy-voice `npm test` **58/58** 通过（含 client 契约测试：无静默 catch、无未解析的 hook 作用域引用）。
- 真机点击实测（打桩）：trace = `a:enter, engine=true, status=stopped, msgs=0, b:prime, vol=1, c:primed, d:latest=none` —— 处理器进入、引擎可用、音频已解锁；`msgs=0` 是因为镜像会话没有真实回答（假 API Key），有回答时即朗读。
- 音量护栏实测：localStorage 置 0 后点击 → 变为 `1`（可听见）。
- 播放排布实测：投递播放事件后浏览器排布 **5.54 秒** @32kHz PCM 缓冲（真会响）。

### 如果你还是听不到
1. 先刷新页面（Cmd+R）让新的客户端 bundle 生效；
2. 确认输入区那组控制里**音量滑杆不在 0**（新按钮会自动拉满，但仍可被滑杆再调低）；
3. 确认系统输出音量与标签页未静音；
4. 点新出现的 ▶ 按钮：它会立即朗读**最新一条已完成的回答**（若当前会话还没有回答则不会有声音）。

## 追加二：点了没反应的真正根因（会话快照里已无 chat）

### 实测（真机浏览器探针）
在 composer 槽里打印插件实际拿到的数据：
- useSession() 快照字段只有 sessionId / queue / pendingSubmissions / running / subagent / removed / openState / openError / hasMore / loadingOlder / promptError / blank / lastAgentError / promptAttempted / awaitingFirstTurn —— **没有 chat**（hasChat: false）。
- 而插件 readVoiceTimeline(snapshot) 的全部文本与最终回答都取自 snapshot.chat.order / chat.nodes.get() / chat.legacy.nodes → 永远为空 → messagesById 与 currentTurnFinals 都是空 → 自动朗读不触发，手动朗读按钮直接 d:latest=none 返回，表现就是点了没反应。
- 该槽位实际注入的钩子（探针打印）：useSessions / useSessionPendingInteraction / usePanelInfo / useWorkspaces / useResource / sessionId / inputActions / useSession / useConversation / useInput / useTrajectory / useChat / useProjection。
- 其中 useChat((state) => state) 返回的正是缺失的投影：{ order, nodes, locations, navigation, timeline, legacy }（order 为数组、nodes.get 为函数、legacy.nodes 为数组），与插件的读取方式完全一致。

### 客户端修复
- VoiceController 签名加入注入的 useChat；快照改为 readVoiceTimeline({ ...useSession((s) => s), chat: useChat((s) => s) || undefined })，一份契约同时兼容新旧 DSH。
- 另外确认：语音控制只在 HDD 视觉模式开启时挂载（SessionScopedVoiceController 里 if (!hddVisualMode) return null），你的 HDD 是开的，所以控件在。

### 验证
- 修复后探针：hasChat true、orderLength 7、nodesGetType function、legacyNodesLength 5、firstNodeKinds = [system-prompt, user, context, context, context, turn-error, turn-tail] → 插件能正常遍历会话拿到回答正文。
- 干净版 bundle 实测控制组：[data-dsh-fairy-play-control] 22x22 @717,873（aria-label 朗读当前回答、enabled）、自动开关 22x22、音量滑杆 66x22 value=1；点击后无 console 错误。
- fairy-voice npm test 58/58 通过（含 VoiceController 渲染无未解析 hook 作用域引用 契约测试）。

### 现在应当怎样
1. 刷新页面（Cmd+R）—— 必须，才会载入新客户端；
2. 输入区左侧出现 ▶「朗读当前回答」：点它立即朗读最新一条已完成的回答（音量 ≤5% 会自动拉满，并在同一手势里解锁音频）；播放中再点即停止；
3. 新的回答结束时会按原设计自动朗读（自动朗读开关默认开启）。

## 追加三：Fairy 本音引擎（本地 GPT-SoVITS）已就位

### 环境限制（实测）
PyPI / HuggingFace / fish.audio 均不可达；**清华 PyPI 镜像 ✓、ModelScope ✓、hf-mirror ✓、bilibili ✓**。故走本地 GPT-SoVITS + 魔搭模型。

### 已安装（全部在工作区，不污染系统）
- 引擎：`fairy-dev-tools/tts/GPT-SoVITS`（git 克隆）+ `.venv`（Python 3.10，uv 创建）
- 关键版本坑（已验证）：**torch 2.14 / torchaudio 2.11 需要 torchcodec，而 torchcodec 原生库在 macOS 27 上 dlopen 失败**；torch 2.5.1 又会被 transformers 的 CVE 校验拦下（要求 ≥2.6）；**最终可用组合：torch 2.6.0 + torchaudio 2.6.0，不需要 torchcodec** ✓
- 另有 macOS 27 兼容性问题：scipy 1.15.3 的 `.so` 被 dyld 拒绝（`__thread_bss` 报错），降到 **scipy 1.13.1** ✓；venv 内原生库已做 ad-hoc 重签名（289 个）
- 模型（魔搭 AI-ModelScope/GPT-SoVITS）：chinese-roberta-wwm-ext-large、chinese-hubert-base、gsv-v2final-pretrained（v2）
- 辅助资产（魔搭 XXXXRT/GPT-SoVITS-Pretrained）：fast_langdetect/lid.176.ftz、G2PWModel（中文前端）
- 依赖：funasr + SenseVoiceSmall（用于自动转写参考音频）、yt-dlp（抓参考音频）

### 插件侧改动（本轮）
- 参考音频路径改为 `DSH_HOME` 感知 + `DSH_FAIRY_REFERENCE_DIR` 可覆盖；参考提示词**惰性读取**（可在运行时安装参考音频，首次缺失只 warn 一次，满足既有契约测试）
- 新增路由 `GET/POST /fairy-voice/reference`：POST {audioBase64, text} 由**宿主**写入 `<DSH_HOME>/fairy-voice/runtime/reference/fairy_ref.wav|txt`（沙箱 agent 写不了 ~/.dsh，但宿主可以）
- `GET /fairy-voice/status` 现在返回 `{backend:'gpt-sovits', voice:'Fairy', referenceInstalled, reason}`；缺参考音频时会明确提示
- 后端优先级：本地 GPT-SoVITS（就绪即用）→ macOS 系统语音（兜底）

### 实测（镜像真机）
- 引擎启动：`fairy voice engine up: http://127.0.0.1:9880`（加载 BERT/CNHuBERT/Text2Semantic/VITS 全部成功）
- `GET /fairy-voice/status` → `{available:true, backend:'gpt-sovits', voice:'Fairy'}`
- `POST /fairy-voice/reference`（8 秒参考 + ASR 文本）→ 安装成功（512KB wav 写入 DSH_HOME/.../fairy_ref.wav）
- `POST /fairy-voice/tts` → **http=200、925440 字节 = 14.46 秒非静音 PCM**，中文前端 `['分析,链路已经打通,主人.']`，**CPU 合成 7 秒（RTF≈0.5，快于实时）**
- 注意：GPT-SoVITS **要求参考音频 3~10 秒**，否则报 `参考音频在3~10秒范围外`（我踩过 22 秒的坑）

### 运维脚本
- 启动：`bash fairy-dev-tools/start-voice-engine.sh`（已在 9880 监听则直接返回；含 `TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1`）
- 停止：`bash fairy-dev-tools/stop-voice-engine.sh`
- 引擎不在时插件自动回退 macOS 系统语音（不会没声音）

### 还差最后一步：干净的 Fairy 参考音频（3~10 秒）
把任意格式的 Fairy 语音片段（尽量无背景音乐、单人、3~10 秒）放到磁盘任意位置，告诉我路径即可：我会用 SenseVoice 自动转写文本并通过 `/fairy-voice/reference` 装进你的 DSH，随后朗读就是 Fairy 本音。

## 最终：Fairy 本音已上线（2026-09-17 深夜）

### 参考音频（来自你给的视频 BV1KQa3eSE4V）
- 该视频 72 秒、句子间有真实静音（无连续 BGM）✓ 切出 3 个候选并自动转写：
  - a) 5.16s「主人，您发呆的样子很好看，相信我，我链接了高清摄像头。」← **已采用**
  - b) 5.30s「您发呆的姿态简直就是艺术品，堪比古典雕塑，马桶上的沉思者。」
  - c) 6.23s「我正在模仿您的声音，安抚小队成员，但某位成员说，我的说话方式很可疑。」
- 资产留档：`improvements/fairy-reference/fairy_ref.wav` + `.txt`（已同时写入你 DSH 的 `~/.dsh/fairy-voice/runtime/reference/`）

### 安装与验证（你的真机 127.0.0.1:3080）
- `POST /fairy-voice/reference` → `{"installed":true,"audioBytes":330318,"text":"主人，您发呆的样子很好看，相信我，我链接了高清摄像头。"}`
- `GET /fairy-voice/status` → `{"available":true,"reason":null,"backend":"gpt-sovits","voice":"Fairy","referenceInstalled":true}`
- `POST /fairy-voice/tts`（'分析完毕，主人。今天也请多指教。'）→ **http=200、243200 字节 = 3.8 秒非静音 PCM、耗时 2.5 秒（快于实时）** ✓
- 试听文件：`improvements/fairy-reference/fairy-voice-test.wav`（32k 单声道）

### 日常运维
- 引擎：`bash fairy-dev-tools/start-voice-engine.sh` / `stop-voice-engine.sh`（当前运行中，127.0.0.1:9880）
- 引擎未运行时自动回退 macOS 系统语音，不会静音
- 换参考音色：把新的 3~10 秒片段 POST 到 `/fairy-voice/reference`（或告诉我路径），文本可用 SenseVoice 自动转写
