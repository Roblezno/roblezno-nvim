# roblezno-nvim

> A personal Neovim configuration focused on bioinformatics, Quarto-based workflows, terminal integration, and understanding how the editor works under the hood.

[![Status](https://img.shields.io/badge/Status-Work%20in%20Progress-orange)](#)
[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-blue.svg)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Language-Lua-blue)](#)

## Overview

`roblezno-nvim` is my personal Neovim setup. It is built to be practical, understandable, and easy to modify rather than a large pre-configured distribution.

The configuration is designed around the way I work: writing code, analyzing data, editing Quarto and Markdown documents, and running code through terminal-based workflows. It is especially oriented toward Python, R, Lua, Vimscript, and bioinformatics-related development.

This setup assumes that you already know what Neovim is, how to install it, and how to open files with it. The goal of this README is to explain what this configuration provides, how to install it, and where to start if you want to understand or modify it.

## Philosophy

I started this configuration because I wanted more control over my development environment.

Full IDEs such as VS Code are powerful, but they can sometimes hide important details behind layers of abstraction. When a language server, formatter, syntax parser, or debugger breaks, it is not always obvious where the problem comes from.

This configuration is my attempt to build an editor that stays close to the underlying tools. It is not minimal for the sake of being minimal, but it avoids unnecessary complexity. Each part of the setup should have a clear purpose and should be easy to inspect when something needs to be changed.

The result is a Neovim setup that aims to be:

- Fast enough for daily work.
- Small enough to understand.
- Useful for real programming and data workflows.
- Flexible enough to keep evolving over time.

## Features

- Plugin management with [lazy.nvim](https://github.com/folke/lazy.nvim).
- Language Server Protocol support through [Mason](https://github.com/mason-org/mason.nvim), [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim), and [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).
- Completion powered by [blink.cmp](https://github.com/Saghen/blink.cmp).
- Treesitter support for Lua, Python, R, and Vim.
- Quarto and Markdown workflow support through [quarto-nvim](https://github.com/quarto-dev/quarto-nvim).
- Code execution from Quarto/Markdown documents using [vim-slime](https://github.com/jpalardy/vim-slime) and tmux.
- File search, text search, and buffer navigation with [Telescope](https://github.com/nvim-telescope/telescope.nvim).
- File explorer support with [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim).
- tmux-aware navigation for a terminal-centered workflow.
- Diagnostics and quickfix improvements with Trouble.
- Session management, todo comments, statusline, notifications, and UI improvements.
- Kanagawa colorscheme with a clean terminal-oriented interface.

## Requirements

Required:

- [Neovim](https://neovim.io/) 0.12 or newer.
- [Git](https://git-scm.com/).
- [ripgrep](https://github.com/BurntSushi/ripgrep), used by Telescope for text search.
- [fd](https://github.com/sharkdp/fd), used by Telescope for file search.
- `make`, required to build `telescope-fzf-native`.

Recommended:

- [tmux](https://github.com/tmux/tmux), especially for the Slime-based code execution workflow.
- A Nerd Font, for better icon rendering in the UI.
- Python and R, if you plan to use the data analysis and bioinformatics parts of the setup.
- The Quarto CLI, if you work with `.qmd` files.

## Installation

Back up any existing Neovim configuration before installing this one.

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

Clone the repository:

```bash
git clone https://github.com/Roblezno/roblezno-nvim.git ~/.config/nvim
```

Start Neovim:

```bash
nvim
```

On the first launch, `lazy.nvim` will automatically bootstrap itself and install the configured plugins.

After installation, useful commands are:

```vim
:Lazy
:Mason
:checkhealth
```

Use `:Lazy` to inspect plugin installation status, `:Mason` to manage external language tools, and `:checkhealth` to diagnose missing dependencies.

## Usage

The leader key is used for most custom mappings. If you are new to the setup, [which-key.nvim](https://github.com/folke/which-key.nvim) can help you discover available mappings as you type them.

### Navigation and Search

| Keymap | Action |
| --- | --- |
| `<leader>ff` | Find files in the current project |
| `<leader>fg` | Search text with live grep |
| `<leader>fb` | List open buffers |
| `<leader>fn` | Search files inside the Neovim config |
| `<leader>e` | Toggle Neo-tree |
| `<leader>bn` | Go to next buffer |
| `<leader>bp` | Go to previous buffer |

### Windows and Splits

| Keymap | Action |
| --- | --- |
| `<leader>sv` | Open a vertical split |
| `<leader>sh` | Open a horizontal split |
| `<C-Up>` | Increase window height |
| `<C-Down>` | Decrease window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |

### Quarto, Markdown, and Code Execution

| Keymap | Action |
| --- | --- |
| `<leader>mp` | Insert a Python code chunk |
| `<leader>mr` | Insert an R code chunk |
| `<leader>mb` | Insert a Bash code chunk |
| `<leader>mc` | Run the current Quarto cell |
| `<leader>ma` | Run current and previous Quarto cells |
| `<leader>mA` | Run all Quarto cells |
| `<leader>rs` | Select the Slime target terminal |
| `<leader>rv` | Send a visual selection to the terminal |
| `<leader>rl` | Send the current line to the terminal |

The Quarto workflow is configured to use Slime as the default code runner. In practice, this means that code chunks can be sent from Neovim to a tmux pane, which keeps editing and execution close together inside the terminal.

## Language Support

The configuration currently installs or enables support for:

- Lua through `lua_ls`.
- Vimscript through `vimls`.
- Python through `pyright`.
- R through `r_language_server`.

Treesitter parsers are configured for:

- Lua.
- Python.
- R.
- Vim.

Additional language servers can be added in `lua/plugins/lsp.lua`. Additional Treesitter parsers can be added in `lua/plugins/treesitter.lua`.

## Project Structure

```text
~/.config/nvim/
├── init.lua
├── lazy-lock.json
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── globals.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins/
│       ├── lsp.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── quarto-md.lua
│       └── ...
└── README.md
```

Important files:

- `init.lua` is the entry point.
- `lua/config/lazy.lua` bootstraps and configures `lazy.nvim`.
- `lua/config/options.lua` contains core Neovim options.
- `lua/config/keymaps.lua` contains custom keymaps.
- `lua/plugins/` contains plugin specifications and plugin-specific configuration.
- `lazy-lock.json` locks plugin versions for reproducible installs.

## Customization

This configuration is intentionally split into small files so that each part is easy to find.

Common changes:

- Edit basic editor behavior in `lua/config/options.lua`.
- Add or modify keymaps in `lua/config/keymaps.lua`.
- Add plugins by creating or editing files in `lua/plugins/`.
- Change language server configuration in `lua/plugins/lsp.lua`.
- Change Treesitter parsers in `lua/plugins/treesitter.lua`.
- Change the colorscheme in `lua/plugins/theme.lua`.

After changing plugin specifications, open Neovim and run:

```vim
:Lazy sync
```

## Status

This is an active personal configuration. It is stable enough for my own daily use, but it should not be treated as a general-purpose Neovim distribution.

The setup will continue to evolve as my workflow changes, especially around bioinformatics, Quarto documents, Python, R, and terminal-based development.

## Contributing and Feedback

This repository is mainly a personal setup, but feedback is welcome. If you notice a bug, an unclear part of the configuration, or a better way to structure something, feel free to open an issue or suggest an improvement.
