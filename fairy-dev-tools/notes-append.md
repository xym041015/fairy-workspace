
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
