# run-storm.nvim

nvim plugin to run shell files in a specific directory for JetBrain application.

## How to use

To run the following command on NeoVim.

```
:St
```

and

Enter the name of the shell file to run.

```
webstorm or goland or something
```

![screenshot](/assets/images/screenshot.png)

## Settings

Pass the directory containing the jetbrain application shell file you wish to run as an argument.

something like this.

```bash
/Users/hisasann/run/shell/directory/[webstorm].sh
```

or

```bash
/Users/hisasann/run/shell/directory/[goland].sh
```

```lua
require("run-storm").setup("/Users/hisasann/run/shell/directory")
```

## Install

### packer.nvim

```
use({ "hisasann/run-storm.nvim" })
```

## License

MIT

## Affected projects and Articles

[Comamoca/runit.nvim: The simple program runner🚀](https://github.com/Comamoca/runit.nvim)

[vim.ui.inputを自作floating windowにした (Vim駅伝)](https://ryota2357.com/blog/2023/neovim-custom-vim-ui-input/)

[How to run terminal command in interactive mode from NeoVim? - Vi and Vim Stack Exchange](https://vi.stackexchange.com/questions/29318/how-to-run-terminal-command-in-interactive-mode-from-neovim)

[1ファイルから始める自作Neovimプラグイン](https://zenn.dev/comamoca/articles/lets-make-neovim-plugin)

[do not show [Process exited] in finished terminals · Issue #14986 · neovim/neovim](https://github.com/neovim/neovim/issues/14986)

[Neovimで非同期でシェルコマンドを実行して完了後に自動で閉じる技術](https://zenn.dev/kawarimidoll/articles/04ffb0d2270328)
