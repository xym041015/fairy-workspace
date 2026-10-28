# Fairy-DSH npm 发布指引

前置:一次 `npm login`(发布需要你的 npm 账号;GitHub fork 需要你的 GitHub 账号)。
当前机器未配置 npm 登录态,以下步骤需要你执行。

## 1. 发布 npm 包

```sh
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发"
bash improvements/npm-publish/prepare-npm-packages.sh        # 或带 scope: bash ... my-scope
for d in improvements/npm-publish/staging/*/; do (cd "$d" && npm publish --access public); done
```

- 产出 6 个包:`dsh-fairy-contracts` + 5 个插件(先发 contracts 再发插件,顺序由 for 循环保证)。
- 包名冲突时用 scope 重跑:`bash improvements/npm-publish/prepare-npm-packages.sh 你的scope`
  (发布为 `@你的scope/dsh-fairy-visual` 等)。
- `@deepseek-ai/*` 运行时依赖已转为 `peerDependencies`(它们是 DSH 宿主私有包,不发布 npm;
  插件只能在 DSH 环境内使用——这正是 DSH 插件的正常形态)。
- staging 目录每次运行脚本都会重建;发布前可用 `npm publish --dry-run` 预览。

## 2. Fork 仓库并推送本地改进

本机没有 `gh` CLI,两种方式任选:

**网页方式**:
1. 浏览器打开 https://github.com/Chengzhibense/Fairy-DSH → 右上 Fork。
2. 本机执行:
   ```sh
   cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH"
   git remote add fork https://github.com/<你的用户名>/Fairy-DSH.git
   git checkout -b local-improvements
   git add -A && git commit -m "Local improvements: HDD fixes, voice pipeline, fairy preset runtime, installer update/uninstall"
   git push fork local-improvements
   ```

**装 gh 后**:`brew install gh && gh auth login && gh repo fork --remote && git push -u fork local-improvements`。

## 3. 上游依赖说明

- 仓库上游是 `private: true` 且未发布 npm;发布前已自动移除该标志。
- 发布属于公开行为,npm 撤回有限制(unpublish 窗口),确认包名与 scope 再发。
