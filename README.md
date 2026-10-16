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
- Treesitter support for Lua, Python, R, Bash, Vim, Markdown, and inline Markdown.
- Quarto and Markdown workflow support through [quarto-nvim](https://github.com/quarto-dev/quarto-nvim).
- Native English/Spanish spell-checking for Markdown and Quarto prose, without automatic completion popups.
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

### Keymap Ownership

- `lua/config/keymaps.lua` owns native editor-wide mappings.
- Plugin-wide actions are declared in the owning plugin's `keys` specification: Telescope, Neo-tree, Slime, and tmux navigation.
- `after/ftplugin/markdown.lua` and `after/ftplugin/quarto.lua` call `lua/config/markup.lua` to install buffer-local document mappings. The shared module owns their definitions, chunk-insertion helper, and cleanup when a buffer's filetype changes.

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
| `<C-h>` | Navigate to the left Neovim/tmux pane |
| `<C-j>` | Navigate to the lower Neovim/tmux pane |
| `<C-k>` | Navigate to the upper Neovim/tmux pane |
| `<C-l>` | Navigate to the right Neovim/tmux pane |
| `<C-\>` | Navigate to the previous Neovim/tmux pane |

The pane-navigation mappings above are available in Normal mode. Inside tmux, `<C-h>`, `<C-j>`, `<C-k>`, and `<C-l>` also navigate from Neovim terminal buffers; FZF terminal buffers retain these keys for FZF.

### Quarto, Markdown, and Code Execution

| Keymap | Mode | Buffer scope | Action |
| --- | --- | --- | --- |
| `<leader>mp` | Normal | Markdown/Quarto | Insert a Python code chunk |
| `<leader>mr` | Normal | Markdown/Quarto | Insert an R code chunk |
| `<leader>mb` | Normal | Markdown/Quarto | Insert a Bash code chunk |
| `<leader>mc` | Normal | Markdown/Quarto | Run the current cell |
| `<leader>ma` | Normal | Markdown/Quarto | Run current and previous cells in the current cell's language |
| `<leader>mA` | Normal | Markdown/Quarto | Run all cells in the current cell's language |
| `<leader>mt` | Normal | Markdown/Quarto | Toggle Markdown/Quarto rendering |
| `<leader>rs` | Normal | Any buffer | Select the Slime target terminal |
| `<leader>rv` | Visual | Any buffer | Send a visual selection to the terminal |
| `<leader>rl` | Normal | Any buffer | Send the current line to the terminal |

The Quarto workflow is configured to use Slime as the default code runner. In practice, this means that code chunks can be sent from Neovim to a tmux pane, which keeps editing and execution close together inside the terminal.

Quarto buffers automatically activate Otter's code-chunk language support. In ordinary Markdown, run `:QuartoActivate` explicitly to enable that support and initialize the cell runner for the current document. Run it again after adding a previously unused chunk language in Markdown. Chunk insertion and rendering mappings are provided by the filetype setup; chunk execution requires the activated document, with the cursor inside a code cell.

In Markdown and Quarto buffers, programming completion, LSP documentation/signature popups, and diagnostics are restricted to fenced code bodies. Prose, YAML front matter, inline code, and fence delimiters do not receive this assistance. Whole-document language servers are detached; Otter retains language support for code chunks. Completion in ordinary source files and the command line is unchanged.

This separation uses the Markdown Treesitter parser through `lua/config/prose.lua`. If the parser is unavailable, `code_chunks()` returns no code-body ranges and `is_prose()` treats the markup buffer as prose: Blink's buffer completion and Noice's LSP popups are suppressed, and forwarded code diagnostics are filtered out. The required Markdown parsers are included in the existing Treesitter installation configuration.

Quarto discovers newly introduced Python, R, and Bash chunk languages when entering/leaving Insert mode or saving a `.qmd` file. It reactivates Otter only when a recognized language lacks its code buffer, reusing existing buffers and language servers. Diagnostics for languages omitted by the rebuilt raft are cleared. Chunk-insertion mappings can trigger discovery before typing; manually typed chunks are retried when leaving Insert mode or saving. A newly started language server may need a moment before completion becomes available. Reopening the document is not required.

Each chunk language needs its matching Treesitter parser and language server. Bash's parser and `bashls` (`bash-language-server`) are included in the existing Treesitter/Mason installation lists; R retains the system language-server setup. These dependencies must finish installing before completion is available.

### Document Workflow Internals

`lua/config/quarto.lua` is the coordination point for Markdown/Quarto events. Syntax-context detection lives in `lua/config/prose.lua`, while buffer-local document mappings live in `lua/config/markup.lua`.

The initialization and event flow is:

1. **Register guards during native configuration.** `lua/config/autocmds.lua` calls `require("config.quarto").setup()` before Lazy loads plugins. The coordinator registers the named `QuartoProse` and `QuartoChunkLanguages` augroups using native APIs. Plugin modules are resolved inside callbacks; language discovery waits for Quarto's configuration table to be available.
2. **Configure the plugins.** The eagerly loaded `lua/plugins/quarto-md.lua` configures languages, completion, diagnostics, and the Slime runner. Blink and Noice retain their options in their own specifications.
3. **Set up each document.** On `FileType`, the coordinator enables Markdown highlighting and parser-aware spelling. Quarto's upstream ftplugin activates Otter automatically for Quarto buffers; ordinary Markdown uses `:QuartoActivate`. The `after/ftplugin` files install the shared document mappings after the regular filetype setup.
4. **Filter LSP attachment.** Otter provides language-specific code buffers and an `otter-ls[buffer]` bridge on the host document. The coordinator permits that bridge and schedules detachment of whole-document servers after their attachment finishes.
5. **Filter forwarded diagnostics.** Only Otter's `otter-lang-*` namespaces are accepted in markup buffers. Diagnostics must start in a fenced code body, and their end positions are clipped to that body's last line. Filtering uses copies so Otter's embedded-buffer diagnostics are not modified; lists are rewritten only when changed to avoid repeated diagnostic events.
6. **Discover new Quarto languages.** For `.qmd` files, Insert-mode entry/exit and saving call `refresh_chunk_languages()`. It compares parsed chunk languages with Otter's existing language buffers and reactivates when one is missing. During this automatic reactivation, the old raft is retained long enough to clear diagnostics for languages omitted from the replacement raft.

Here, an Otter **raft** is the record for one host document and its language-specific buffers. Access to its buffer and diagnostic-namespace tables, along with Otter's client/namespace naming conventions, is localized in `config/quarto.lua`. These assumptions should be reviewed against the pinned upstream implementation when updating Otter.

`config/prose.lua` reports code-body rows using zero-based, inclusive `start_row` and exclusive `end_row` values. Fence delimiters and language labels are outside those ranges. Blink consults `is_prose()` for buffer completion; Noice calls the coordinator's `suppress_lsp_message()` helper, which also extends an existing popup lifetime predicate so it closes when the cursor enters prose.

### Prose Spelling

Markdown and Quarto prose automatically use Neovim's built-in English and Spanish spell-checking (`spelllang=en,es`). Words accepted by either language are considered correct. This checks spelling, not grammar or writing style, and does not add a language server or automatic suggestion menus.

Treesitter marks prose for spelling and excludes fenced/indented code blocks (including their comments and strings), front matter, inline code, link destinations, and autolinks. Spell-checking stays off if the Markdown highlighter cannot start or the inline Markdown parser is unavailable, rather than treating code as prose.

Useful native commands:

| Command | Action |
| --- | --- |
| `]s` | Jump to the next misspelled word |
| `[s` | Jump to the previous misspelled word |
| `z=` | Show correction suggestions |
| `zg` | Add a scientific term, name, or other accepted word to the personal word list |
| `zG` | Ignore a word for the current Neovim session |
| `:setlocal nospell` | Turn spell-checking off in the current window |
| `:setlocal spell` | Turn spell-checking back on |

For a document written in just one language, use `:setlocal spelllang=en` or `:setlocal spelllang=es` to avoid accepting words from the other language. The default for newly opened Markdown/Quarto buffers remains bilingual.

If a dictionary is missing, Neovim may ask permission to download it when spelling is enabled; Spanish commonly needs this on the first use. See `:help spell` and `:help spell-SpellFileMissing`. The configuration does not silently download dictionaries.

## Language Support

The configuration currently installs or enables support for:

- Lua through `lua_ls`.
- Vimscript through `vimls`.
- Python through `pyright` and `ruff`.
- R through `r_language_server`.
- Bash through `bashls`.

For Python, Pyright provides type checking and language intelligence, while Ruff provides lint diagnostics, code actions, import organization, and formatting. Ruff follows project-level configuration from `pyproject.toml`, `ruff.toml`, or `.ruff.toml`; fixes and formatting are not run automatically on save.

Treesitter parsers are configured for:

- Lua.
- Python.
- R.
- Bash.
- Vim.
- Markdown.
- Inline Markdown.

Parser installation and highlighting are configured separately. `lua/plugins/treesitter.lua` installs parsers and queries, while `lua/config/autocmds.lua` starts source-file highlighting for the `lua`, `python`, `r`, `sh`, `bash`, and `vim` filetypes. Shell buffers with the `sh` filetype explicitly use the Bash parser. Markdown and Quarto use the document highlighting/spelling setup in `lua/config/quarto.lua`.

If a source parser is unavailable when a buffer opens, highlighting activation is skipped without interrupting file loading. Reopen the buffer after parser installation finishes to retry activation.

Treesitter folding is configured independently through Neovim's native fold expression in `lua/config/options.lua`. This highlighting setup does not enable nvim-treesitter's experimental indentation feature.

Additional language servers can be added in `lua/plugins/lsp.lua`. Additional Treesitter parsers can be added in `lua/plugins/treesitter.lua`; to enable highlighting for another ordinary source language, also add its filetype to the `SourceTreesitter` autocmd in `lua/config/autocmds.lua` and account for any parser-name mismatch.

## Project Structure

```text
~/.config/nvim/
├── after/
│   ├── ftplugin/
│   │   ├── markdown.lua
│   │   └── quarto.lua
│   └── queries/
│       └── markdown/
│           └── highlights.scm
├── init.lua
├── lazy-lock.json
├── lua/
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── globals.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── markup.lua
│   │   ├── options.lua
│   │   ├── prose.lua
│   │   └── quarto.lua
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
- `lua/config/keymaps.lua` contains native editor-wide keymaps.
- `lua/config/markup.lua` owns shared document mappings, installed buffer-locally by the Markdown/Quarto files in `after/ftplugin/`.
- `lua/config/prose.lua` identifies fenced code-body ranges for the document assistance policy.
- `lua/config/quarto.lua` coordinates document autocmds, Otter language discovery, LSP/diagnostic guards, and Noice popup filtering.
- `lua/plugins/` contains plugin specifications, plugin-wide mappings, and plugin-specific configuration.
- `lazy-lock.json` locks plugin versions for reproducible installs.

## Customization

This configuration is intentionally split into small files so that each part is easy to find.

Common changes:

- Edit basic editor behavior in `lua/config/options.lua`.
- Add or modify native editor-wide keymaps in `lua/config/keymaps.lua`, plugin-wide mappings in the owning plugin's `keys` specification, and Markdown/Quarto mappings in `lua/config/markup.lua`.
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
