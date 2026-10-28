# fairy-workspace

Fairy DSH 开发工作区（Fairy-DSH 仓库之外的部分）。

主仓库（5 个 Fairy 插件套件）：https://github.com/xym041015/Fairy-DSH

## 目录

| 路径 | 内容 |
|---|---|
| `install-fairy-to-dsh.sh` | Fairy-DSH → DSH profile 安装 / `--check` / `--rollback` / `--uninstall` / `--update` 脚本（369 行） |
| `FAIRY-INSTALL.md` | 安装说明、路线 A（持久安装）/ 路线 B（运行时注入） |
| `LIMITATIONS.md` | 安装限制清单与逐条复核记录（A/B 两组） |
| `fairy-dev-tools/` | 开发期 CDP 探针、截图、A/B 校验、补丁生成脚本（js/py/sh，约 390 个文件） |
| `improvements/` | 语音修复与 HDD 修复的补丁 + 分析文档、参考音频、npm 发布 staging |

## 说明

- `fairy-dev-tools/edge-profile2/`（Edge/Chromium 浏览器 profile，约 376M）与 `fairy-dev-tools/cache/`（约 16M）是纯运行时垃圾，未纳入版本库。
- `fairy-dev-tools/tts` 原是符号链接，指向 `~/Library/Application Support/fairy-tts`（GPT-SoVITS 引擎 4.3G），不随仓库分发；TTS 路径通过 `FAIRY_HOME` / `DSH_FAIRY_REFERENCE_DIR` 注入。
- `fairy-dev-tools/mirror/` 是 DSH_HOME 的镜像快照，其中的凭据文件与 sessions 已排除。

## 许可

除文件另有说明外按 Apache License 2.0 发布。
