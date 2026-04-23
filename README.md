# 遗言 / LastWords

### 当你的 Claude Code 会话即将被上下文吞掉,给它一次体面的交接。

---

你在做一个 PR。

63 个 commit squash 成 1 个、rebase 到 main、解完一个棘手的冲突、补上 DCO sign-off、修完 ruff——眼看就要推了。

然后你在 `git diff origin/main` 里扫了一眼 changed files,心里一沉:这个 PR 的 scope 不对。里面混了一堆旧分支夹带进来的 runtime 改动,跟 PR 目标不是一回事。

你决定重新剥离 scope。但就在这时,你发现对话已经跑到 700k tokens,模型开始忘前文了。

你新开一个会话。对着空白窗口,你试图回忆:

- 刚才哪些文件被我判定为"夹带货"、哪些是"核心改动"?判断依据是什么?
- rebase 时那个 `data.py` 冲突我是怎么解的?upstream 加了什么、我加了什么、为什么两段可以共存?
- nightly CI 那个 label 我选的是"每模型一个 label"还是"一个 label + 参数化"?为什么?

`git log` 里没有这些信息。commit message 里也没有。它们只存在于那个已经死掉的会话里。

**你丢的不是聊天记录,是工作状态。**

`/遗言` 就是把这些隐性进度显式化、落盘,交给下一个会话。

## 它做什么

在 Claude Code 里输入 `/遗言`(或 `/lastwords`),它会回顾当前会话,整理出:

- **项目背景**——这个 PR / 任务是什么、仓库结构、当前分支
- **已完成的工作**——具体做了什么,精确到 commit hash 和文件
- **未完成的工作**——还差什么,按优先级排
- **关键决策与发现**——为什么这么做、踩过哪些坑、排除了哪些方向
- **下一步建议**——新会话接手后第一步该做什么

然后存成一个 Markdown 文件,丢在当前项目的 `遗言/` 目录下。

新会话 `cat` 一下这个文件,30 秒进入状态。

## 文件名就是 TL;DR

普通 handoff 文件长这样:

```
handoff_2026_04_23_143052.md
```

看不出里面是啥。打开之前得先猜。

`/遗言` 生成的长这样:

```
遗言/PR里63个commit残骸squash完了但旧分支夹带货还没从changed_files剥干净-143052_23042026.md
遗言/明明只差attention层的fp16对齐就能跑通了-091523_23042026.md
遗言/ResNet推理结果和PyTorch差了0.3%我真的会谢-220147_23042026.md
```

不用打开,看文件名就知道:什么任务、卡在哪一步、值不值得现在接着干。

轻小说标题不是搞笑,是压缩——把上下文最关键的一句塞进文件名。

## 和 `/compact` 的区别

很多人第一反应是:"这不就是 `/compact` 吗?" 不是。

|  | `/compact` | `/遗言` |
|---|---|---|
| 目标 | 压缩当前会话,让它继续 | 给**下一个**会话准备交接文档 |
| 前提 | 当前会话还救得回来 | 当前会话随时会死,或已经不可靠 |
| 产出 | 留在会话内存里 | 落盘成 Markdown |
| 结构 | 自动摘要,不可控 | 背景 / 进度 / 决策 / 下一步,显式分块 |

一句话:**`/compact` 是续命,`/遗言` 是交接。** 还能抢救就先 `/compact`,感觉这把真要死了再 `/遗言`。

## 安装

一键:

```bash
curl -fsSL https://raw.githubusercontent.com/zuiho-kai/claude-lastwords/master/install.sh | bash
```

用 gh:

```bash
gh repo clone zuiho-kai/claude-lastwords /tmp/lastwords && bash /tmp/lastwords/install.sh
```

手动(两个文件丢进 `~/.claude/commands/` 就行):

```bash
mkdir -p ~/.claude/commands
curl -fsSL https://raw.githubusercontent.com/zuiho-kai/claude-lastwords/master/遗言.md -o ~/.claude/commands/遗言.md
curl -fsSL https://raw.githubusercontent.com/zuiho-kai/claude-lastwords/master/lastwords.md -o ~/.claude/commands/lastwords.md
```

## 使用

在 Claude Code 里:

```
/遗言
```

或者英文输入法下:

```
/lastwords
```

生成的文件在当前项目的 `遗言/{标题}-{时间戳}.md`。

新会话里:

```
请阅读这份遗言文件,了解之前会话的背景和进度,然后继续未完成的工作:
cat 遗言/PR里63个commit残骸squash完了但旧分支夹带货还没从changed_files剥干净-143052_23042026.md
```

## 什么时候该用

判断标准只有一条:

> 如果这个会话现在死掉,我明天能不能接上?

能接上,不用。接不上——哪怕只是有点悬——就 `/遗言`。

典型场景:

- 上下文快满了,回答开始明显变差(模型在忘前文)
- 中转站签名 / 历史记录不稳
- 复杂 PR 做到 squash / rebase / scope 清理阶段,换会话风险高
- 调试做了一半,今天得先停
- 要换终端 / 换机器继续干

如果你的任务通常几轮就结束,这东西对你没用。如果你经常"思路还在,窗口没了",它就是为你做的。

## License

MIT
