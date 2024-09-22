# run-storm.nvim

nvim plugin to run shell files in a specific directory.

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

## Affected projects

[Comamoca/runit.nvim: The simple program runner🚀](https://github.com/Comamoca/runit.nvim)
