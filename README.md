# roblezno-nvim

> A personal Neovim configuration focused on bioinformatics, Quarto-based workflows, terminal integration, and understanding how the editor works under the hood.

[![Status](https://img.shields.io/badge/Status-Work%20in%20Progress-orange)](#)
[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-blue.svg)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Language-Lua-blue)](#)

## Overview

This config started as a minimal setup for learning and using nvim. 

As I started using it more and more it grew to a point where it no longer is a small setup I believe. 
My goal now is for this config to be a polished IDE for bioinformatic usage (mainly). 
This is where version 0.2 (the current one) comes into place. This is still a personal config, 
everything is set up for my programming style and usage of Nvim. 

This Neovim setup aims to be:

- Fast enough for daily work.
- Useful for real programming and data workflows.
- Flexible enough to keep evolving over time.

## Status

This is an active personal configuration. It is stable enough for my own daily use, but it should not be treated as a general-purpose Neovim distribution.
The setup will continue to evolve as my workflow changes, especially around bioinformatics, Quarto documents, Python, R, and terminal-based development.


## Features

- Plugin management with [lazy.nvim](https://github.com/folke/lazy.nvim).
- Native Neovim LSP support, using [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for server definitions and [Mason](https://github.com/mason-org/mason.nvim)/[mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim) for tool installation and enabling installed servers.
- Completion powered by [blink.cmp](https://github.com/Saghen/blink.cmp).
- Treesitter support for Lua, Python, R, Bash, Vim, Markdown, and inline Markdown.
- Nextflow filetype/syntax support and language-server integration.
- Quarto and Markdown workflow support through [quarto-nvim](https://github.com/quarto-dev/quarto-nvim).
- Native English/Spanish spell-checking for Markdown and Quarto prose, without automatic completion popups.
- Code execution from Quarto/Markdown documents using [vim-slime](https://github.com/jpalardy/vim-slime) and tmux.
- File search, text search, and buffer navigation with [Telescope](https://github.com/nvim-telescope/telescope.nvim).
- File explorer support with [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim).
- Discoverable which-key groups, manual source formatting, and Neovim's bundled undo-tree viewer.
- tmux-aware navigation for a terminal-centered workflow.
- Diagnostics and quickfix improvements with Trouble.
- Session management, todo comments, statusline, notifications, and UI improvements.
- Kanagawa colorscheme with a clean terminal-oriented interface.

## Requirements

Required for this configuration on Linux:

- [Neovim](https://neovim.io/) 0.12 or newer.
- [Git](https://git-scm.com/).
- [ripgrep](https://github.com/BurntSushi/ripgrep), used by Telescope for text search.
- [fd](https://github.com/sharkdp/fd), used by Telescope for file search.
- `make` and a C compiler such as GCC or Clang, used to build `telescope-fzf-native` and Treesitter parsers.
- `curl` and GNU `tar`, used for parser downloads and extraction.
- [`tree-sitter-cli`](https://github.com/tree-sitter/tree-sitter/tree/master/crates/cli) **0.26.1 or newer**, installed through a package manager rather than npm, as required by the pinned Treesitter revision.
- `unzip` and `gzip`, used by Mason's package installers alongside the tools above.
- Node.js and npm for the configured Pyright, Vimscript, and Bash language servers.

The [pinned Treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter/blob/910fdf6f49e9dee7e7257c7d11a76b040fdfb9de/README.md#requirements) are the basis for the Neovim, compiler, and CLI requirements above. Mason packages can have additional language-specific requirements; see the language-support table below and `:help mason-requirements`.

Workflow-specific requirements:

- [tmux](https://github.com/tmux/tmux) for the configured Slime target and cross-pane navigation. The tmux side of [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator#installation) needs its corresponding configuration.
- The [Quarto CLI](https://quarto.org/docs/get-started/) for document preview/rendering.
- Python, R, or Bash and the project's packages in the terminal used to execute code. R also needs the `languageserver` package for editor assistance.
- Java **17 or newer** for the configured Nextflow language server; the Nextflow CLI and workflow dependencies are needed separately to execute pipelines.
- A Nerd Font is recommended for the configured icons.

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

On the first launch, `lazy.nvim` bootstraps itself and installs missing plugins using the recorded revisions where available. Treesitter requests the configured parsers asynchronously, and Mason requests the servers listed in `lua/plugins/lsp.lua`. The external R package and workflow runtimes are installed separately.

`lazy-lock.json` records plugin commits. On an existing installation, `:Lazy restore` restores those revisions. Mason-managed tool versions and project language environments are separate from that plugin lockfile.

After installation, useful commands are:

```vim
:Lazy
:Mason
:checkhealth
```

Use `:Lazy` to inspect plugin installation status, `:Mason` to manage external language tools, and `:checkhealth` to diagnose missing dependencies.

## Startup and Ownership

1. `init.lua` loads `config.lazy`, which bootstraps lazy.nvim and adds it to the runtime path.
2. Native configuration loads in this order: `config.globals`, `config.autocmds`, `config.options`, then `config.keymaps`. This sets the leaders and registers document guards before plugin setup.
3. Lazy imports `lua/plugins/`, configures startup plugins, and registers on-demand triggers. The Kanagawa specification has priority `1000` so the colorscheme is initialized early.
4. Filetype events start the configured highlighters and run filetype setup. The Markdown/Quarto `after/ftplugin` files install shared buffer-local mappings with cleanup for filetype changes.
5. `config.quarto` coordinates document events, Otter integration, and Noice popup policy. `config.prose` supplies syntax context, while each plugin specification owns its options.

This is a personal configuration using the lazy.nvim plugin manager. The document-specific event sequence is detailed under **Document Workflow Internals**.

## Usage

Both `<leader>` and `<localleader>` are **Space**, configured in `lua/config/globals.lua`. If you are new to the setup, [which-key.nvim](https://github.com/folke/which-key.nvim) can help you discover available mappings as you type them.

### Keymap Ownership

- `lua/config/keymaps.lua` owns native editor-wide mappings.
- Plugin-wide actions are declared in the owning plugin's `keys` specification: Telescope, Neo-tree, Slime, and tmux navigation.
- `after/ftplugin/markdown.lua` and `after/ftplugin/quarto.lua` call `lua/config/markup.lua` to install buffer-local document mappings. The shared module owns their definitions, chunk-insertion helper, and cleanup when a buffer's filetype changes.

Which-key labels the existing prefixes so their purpose is visible while choosing an action:

| Prefix | Group |
| --- | --- |
| `<leader>f` | Find |
| `<leader>b` | Buffers |
| `<leader>s` | Splits |
| `<leader>m` | Markdown/Quarto |
| `<leader>r` | Run |
| `<leader>t` | Trouble |
| `<leader>w` | Sessions |
| `<leader>c` | Code |

The Run group is available in Normal and Visual modes for Slime's execution actions. Use `<leader>?` in Normal mode to inspect the current buffer's local mappings. Group labels live in `lua/plugins/which-key.lua`; the actions retain the ownership described above.

### Selective Plugin Loading

Loading decisions are declared in the individual plugin specifications:

| Component | Initialization |
| --- | --- |
| Telescope | A configured picker key or `:Telescope` loads it, runs setup, and activates the native fzf extension before the requested action. |
| Quarto | The `quarto` filetype or a declared Quarto command loads it and applies its options. Ordinary Markdown starts its Otter session explicitly with `:QuartoActivate`. |
| Native document guards | `config/autocmds.lua` initializes `config/quarto.lua` during startup so the guards are registered before Quarto/Otter activation. |
| Treesitter | Eager loading is required by the pinned main-branch plugin and supplies parser support for document setup. |

Lazy also loads a plugin when one of its Lua modules is required. The shared document mappings resolve `quarto.runner` when a run action is used; Markdown's document activation is performed through `:QuartoActivate`.

### Navigation and Search

| Keymap | Action |
| --- | --- |
| `<leader>ff` | Find files in the current project |
| `<leader>fg` | Search text with live grep |
| `<leader>fb` | List open buffers |
| `<leader>fn` | Search files inside the Neovim config |
| `<leader>fr` | Find recently opened files |
| `<leader>fw` | Search the word under the cursor in the current working directory |
| `<leader>fh` | Search help tags |
| `<leader>fk` | Search keymaps |
| `<leader>e` | Toggle Neo-tree |
| `<leader>bn` | Go to next buffer |
| `<leader>bp` | Go to previous buffer |

The search mappings above use Normal mode. Recent files come from Neovim's file history; they are not restricted to the current project. The keymap picker includes Normal, Insert, command-line, and Visual mappings by default.

### Undo History

In Normal mode, `<leader>u` toggles Neovim 0.12's bundled undo-tree viewer. The mapping first runs `:packadd nvim.undotree`, then `:Undotree`, so the optional package is loaded when needed.

Moving the cursor through the tree changes the source buffer to the corresponding undo state. This uses the native undo history, including persistent history configured in `lua/config/options.lua`. See `:help package-undotree` and `:help undo-tree`.

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

### Diagnostics and Sessions

These Normal-mode actions belong to `lua/plugins/trouble.lua` and `lua/plugins/auto-session.lua`:

| Keymap | Action |
| --- | --- |
| `<leader>tx` | Toggle workspace diagnostics |
| `<leader>tX` | Toggle current-buffer diagnostics |
| `<leader>ts` | Toggle document symbols |
| `<leader>tl` | Toggle LSP definitions/references in a right-side Trouble view |
| `<leader>tL` | Toggle the location list |
| `<leader>tQ` | Toggle the quickfix list |
| `<leader>wr` | Restore the current working directory's session |
| `<leader>ws` | Save the current working directory's session |
| `<leader>wd` | Delete the current working directory's session |

Auto-session's startup restoration is disabled; `<leader>wr` provides the explicit restore action.

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
| `<leader>mv` | Normal | Markdown/Quarto | Preview the document with Quarto |
| `<leader>mV` | Normal | Markdown/Quarto | Close the document's Quarto preview |
| `<leader>rs` | Normal | Any buffer | Select the Slime target terminal |
| `<leader>rv` | Visual | Any buffer | Send a visual selection to the terminal |
| `<leader>rl` | Normal | Any buffer | Send the current line to the terminal |

The Quarto workflow is configured to use Slime as the default code runner. In practice, this means that code chunks can be sent from Neovim to a tmux pane, which keeps editing and execution close together inside the terminal.

Preview actions use the Quarto CLI and load the plugin through its existing command triggers. Run the close-preview shortcut from the document that started the preview. Previewing ordinary Markdown does not replace the explicit Otter activation described below.

Quarto buffers automatically activate Otter's code-chunk language support. In ordinary Markdown, run `:QuartoActivate` explicitly to enable that support and initialize the cell runner for the current document. Run it again after adding a previously unused chunk language in Markdown. Chunk insertion and rendering mappings are provided by the filetype setup; chunk execution requires the activated document, with the cursor inside a code cell.

In Markdown and Quarto buffers, programming completion, LSP documentation/signature popups, and diagnostics are restricted to fenced code bodies. Prose, YAML front matter, inline code, and fence delimiters do not receive this assistance. Whole-document language servers are detached; Otter retains language support for code chunks. Completion in ordinary source files and the command line is unchanged.

This separation uses the Markdown Treesitter parser through `lua/config/prose.lua`. If the parser is unavailable, `code_chunks()` returns no code-body ranges and `is_prose()` treats the markup buffer as prose: Blink's buffer completion and Noice's LSP popups are suppressed, and forwarded code diagnostics are filtered out. The required Markdown parsers are included in the existing Treesitter installation configuration.

Quarto discovers newly introduced Python, R, and Bash chunk languages when entering/leaving Insert mode or saving a `.qmd` file. It reactivates Otter only when a recognized language lacks its code buffer, reusing existing buffers and language servers. Diagnostics for languages omitted by the rebuilt raft are cleared. Chunk-insertion mappings can trigger discovery before typing; manually typed chunks are retried when leaving Insert mode or saving. A newly started language server may need a moment before completion becomes available. Reopening the document is not required.

Each chunk language needs its matching Treesitter parser and language server. Bash's parser and `bashls` (`bash-language-server`) are included in the existing Treesitter/Mason installation lists; R retains the system language-server setup. These dependencies must finish installing before completion is available.

### Document Workflow Internals

`lua/config/quarto.lua` is the coordination point for Markdown/Quarto events. Syntax-context detection lives in `lua/config/prose.lua`, while buffer-local document mappings live in `lua/config/markup.lua`.

The initialization and event flow is:

1. **Register guards during native configuration.** `lua/config/autocmds.lua` calls `require("config.quarto").setup()` before Lazy loads plugins. The coordinator registers the named `QuartoProse` and `QuartoChunkLanguages` augroups using native APIs. Plugin modules are resolved inside callbacks; language discovery waits for Quarto's configuration table to be available.
2. **Declare on-demand entry points.** `lua/plugins/quarto-md.lua` declares the `quarto` filetype and Quarto commands as loading triggers. Neovim 0.12 detects `.qmd` files natively. On load, Lazy configures Quarto's languages, completion, diagnostics, and Slime runner before dispatching the requested command or replaying `FileType`. Blink and Noice retain their options in their own specifications.
3. **Set up each document.** For filetype-triggered loading, Lazy's replay runs Quarto's ftplugin after its options are configured, allowing automatic Otter activation. The coordinator's `FileType` handler enables Markdown highlighting and parser-aware spelling. The `after/ftplugin` files install shared document mappings, with native filetype cleanup supporting replay. Ordinary Markdown uses explicit `:QuartoActivate`.
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

The declared language support is summarized below. Listed Treesitter parsers are installed by `lua/plugins/treesitter.lua`; server definitions and overrides come from nvim-lspconfig and `lua/plugins/lsp.lua`.

| Language / filetype | Parser or syntax | Language server | Server installation | Runtime / environment |
| --- | --- | --- | --- | --- |
| Lua (`lua`) | `lua` | `lua_ls` | Mason: `lua-language-server` | LuaLS package; Neovim executes this configuration |
| Vimscript (`vim`) | `vim` | `vimls` | Mason: `vim-language-server` | Node.js/npm for the server |
| Python (`python`) | `python` | `pyright`, `ruff` | Mason: `pyright`, `ruff` | Node.js/npm for Pyright; the project's Python and packages for analysis/execution |
| R (`r`) | `r` | `r_language_server` | R package `languageserver`, outside Mason | The intended R executable and its package library |
| Bash / shell (`bash`, `sh`) | `bash` | `bashls` | Mason: `bash-language-server` | Node.js/npm for the server; Bash for execution |
| Nextflow (`nextflow`) | Vim syntax from `vim-language-nextflow`; no configured Treesitter parser | `nextflow_ls` | Mason: `nextflow-language-server` | Java 17+ for the server; Nextflow and workflow dependencies for execution |
| Markdown / Quarto (`markdown`, `quarto`) | `markdown`, `markdown_inline` | Otter forwards the R/Python/Bash servers for code chunks | Same server installations as the source-language rows | Quarto CLI for preview; the selected interpreter for chunk execution |

Mason installs the six servers listed in `ensure_installed`. Its mason-lspconfig integration enables Mason-installed servers by default through `vim.lsp.enable()`. Neovim's native client handles LSP communication; Mason is the tool installer. R is enabled explicitly because its server is managed outside Mason.

Nextflow's filetype detection and Vim syntax come from `lua/plugins/nextflow.lua`. The language server's semantic-token provider is disabled in `lua/plugins/lsp.lua`, leaving syntax highlighting to that plugin. The pinned [Nextflow server definition](https://github.com/neovim/nvim-lspconfig/blob/3e8d598d3b5f8338a41699c436e5fa11d2666cf0/lsp/nextflow_ls.lua) documents the Java 17+ requirement.

### R Language Server

Install `languageserver` from the R installation intended for editor assistance:

```r
install.packages("languageserver")
```

The [pinned server definition](https://github.com/neovim/nvim-lspconfig/blob/3e8d598d3b5f8338a41699c436e5fa11d2666cf0/lsp/r_language_server.lua) starts `R --no-echo -e 'languageserver::run()'`. `R` is resolved from Neovim's `PATH`; it is not hard-coded to a system path. For the intended system-R workflow, make that R executable available to Neovim and install the package in a library it can find.

### Analysis and Execution Environments

- **Editor assistance:** language-server processes inherit Neovim's environment, with Mason's executable directory prepended to `PATH`. Python analysis also follows Pyright's project/workspace settings. This configuration does not select a project-specific Python interpreter.
- **Code execution:** Slime sends text to an existing tmux pane. The configured defaults are socket `default` and target `{last}`; use `<leader>rs` to select the destination and start the required Python, R, or Bash session there.
- **Matching environments:** choose the intended project environment for analysis and start the matching interpreter with its packages in the target pane. Selecting a Slime pane does not change the language servers' interpreter or package environment.
- **Mixed-language documents:** the current-cell, run-above, and run-all shortcuts use the current cell's language by default. Use a suitable interpreter in the selected pane; the mappings do not switch between language-specific REPLs automatically.

For Python, Pyright provides type checking and language intelligence, while Ruff provides lint diagnostics, code actions, import organization, and formatting. Ruff follows project-level configuration from `pyproject.toml`, `ruff.toml`, or `.ruff.toml`; fixes and formatting are not run automatically on save.

### Manual Source Formatting

Use `<leader>cf` in Normal mode to format the current source buffer through Neovim's native LSP client. The mapping in `lua/config/keymaps.lua` checks attached clients for whole-document formatting support when invoked:

- **Python:** use only the attached `ruff` client.
- **Other source buffers:** use the sole available formatting client, or choose one with the native provider picker when several qualify. Client names and IDs distinguish the choices.
- **Unavailable formatter:** show an informational message. Installing or attaching a language server alone does not imply that it supports formatting.

The request targets one client and runs synchronously using Neovim's defaults. It is an explicit whole-buffer action; it does not format on save. Markdown/Quarto documents and special buffers are excluded from this shortcut because mixed-language formatting needs its own agreed workflow. See `:help vim.lsp.buf.format()`.

### Syntax Highlighting

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

### Native Syntax Selection

Enter Visual mode with `v`, then use Neovim 0.12's native syntax-selection mappings:

| Key | Action |
| --- | --- |
| `an` | Select a parent syntax node |
| `in` | Select the previous (or first) child syntax node |
| `]n` | Select the next syntax node |
| `[n` | Select the previous syntax node |

These mappings use the buffer's Treesitter parser. When no parser is available, `an` and `in` can fall back to LSP selection ranges if an attached server supports them. See `:help treesitter-defaults`.

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
├── CHANGELOG.md
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
├── README.md
└── VERSION
```

Important files:

- `init.lua` is the entry point.
- `lua/config/lazy.lua` bootstraps and configures `lazy.nvim`.
- `lua/config/globals.lua` defines the leaders before mappings are registered.
- `lua/config/autocmds.lua` owns native editor events and initializes the document coordinator.
- `lua/config/options.lua` contains core Neovim options.
- `lua/config/keymaps.lua` contains native editor-wide keymaps.
- `lua/config/markup.lua` owns shared document mappings, installed buffer-locally by the Markdown/Quarto files in `after/ftplugin/`.
- `lua/config/prose.lua` identifies fenced code-body ranges for the document assistance policy.
- `lua/config/quarto.lua` coordinates document autocmds, Otter language discovery, LSP/diagnostic guards, and Noice popup filtering.
- `lua/plugins/` contains plugin specifications, plugin-wide mappings, and plugin-specific configuration.
- `lazy-lock.json` locks plugin versions for reproducible installs.
- `VERSION` records the configuration version; `CHANGELOG.md` summarizes its releases.

## Customization

This configuration is intentionally split into small files so that each part is easy to find.

Common changes:

- Edit basic editor behavior in `lua/config/options.lua`.
- Add or modify native editor-wide keymaps in `lua/config/keymaps.lua`, plugin-wide mappings in the owning plugin's `keys` specification, and Markdown/Quarto mappings in `lua/config/markup.lua`.
- Add plugins by creating or editing files in `lua/plugins/`.
- Change language server configuration in `lua/plugins/lsp.lua`.
- Change Treesitter parsers in `lua/plugins/treesitter.lua`.
- Change the colorscheme in `lua/plugins/theme.lua`.

Restart Neovim after editing configuration, then use `:Lazy` to inspect the plugin state. Select the operation that matches the change:

| Command | Purpose |
| --- | --- |
| `:Lazy install` | Install missing plugins |
| `:Lazy restore` | Restore plugin revisions from `lazy-lock.json` |
| `:Lazy update` | Update plugin revisions; individual plugins can be selected in the Lazy UI |
| `:Lazy sync` | Combine cleanup, installation, and updates |

The update checker is enabled with notifications disabled. Plugin updates and their generated lockfile changes are reviewed separately from configuration edits. When updating nvim-treesitter, its `:TSUpdate` build hook keeps parser revisions aligned with the plugin.

Inactive customization examples are labeled in the plugin files. They provide reference settings alongside comments explaining the active configuration.

## Contributing and Feedback

This repository is mainly a personal setup, but feedback is welcome. If you notice a bug, an unclear part of the configuration, or a better way to structure something, feel free to open an issue or suggest an improvement.
