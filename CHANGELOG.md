# Changelog

`VERSION` records the current configuration version. Intermediate patch numbers
match refinement step numbers; merge commits do not increment them again.
Changes accumulate under Unreleased until the completed refinement is summarized
as version 2.0.0.

## Unreleased

### 1.0.10 — 2026-10-17

#### Changed

- Reconcile the README with startup order, mapping ownership, pinned Treesitter
  and Mason requirements, and language support including Nextflow and external R.
- Explain analysis versus tmux execution environments, current-language chunk
  execution, plugin restoration/updates, and existing diagnostics/session actions.
- Add missing plugin documentation headers and correct descriptions of
  lazy.nvim, Mason, search highlighting, rendering, and integration ownership.
- Retain inactive customization examples with explicit labels and replace copied
  placeholders with explanations of the active configuration.
- Defer Gitsigns to version `2.1.0`, on hold. Skip the step 9 intermediate version
  and finalize the existing refinements as `2.0.0` after this documentation step.

### 1.0.8 — 2026-10-16

#### Implemented

- **Discoverability:** Add which-key labels for Find, Buffers, Splits,
  Markdown/Quarto, Run, Trouble, Sessions, and Code.
- Add Telescope shortcuts for recent files, the word under the cursor, help
  tags, and keymaps, plus buffer-local Quarto preview and close-preview actions.
- Add manual native LSP source formatting: Ruff for Python and a single
  formatting provider for other source buffers, with selection when needed.
- Add an on-demand shortcut for Neovim's bundled undo-tree viewer.

#### Changed

- Document the accepted shortcuts, formatting scope and provider selection,
  undo history, and Neovim 0.12's native Visual-mode syntax selection.

### 1.0.7 — 2026-10-16

#### Changed

- **Plugin loading:** Load Telescope through its picker keys or `:Telescope`,
  with setup and native fzf activation performed on load.
- Load Quarto through the `quarto` filetype or its existing commands, with
  document guards registered at startup and explicit Markdown activation.
- Document filetype detection, configuration/event ordering, and intentional
  eager initialization for document guards and Treesitter.
- Set the final refinement release target to `2.0.0`; intermediate step
  versions continue through `1.0.10` before the release milestone.

### 1.0.6 — 2026-10-16

#### Changed

- **Quarto workflow:** Centralize document highlighting/spelling, LSP and
  diagnostic guards, and chunk-language discovery in `config/quarto.lua`,
  registered before plugin setup.
- Localize Otter raft access, client/namespace conventions, reactivation, and
  stale-diagnostic cleanup. Share Noice popup filtering through the coordinator.
- Annotate syntax-context helpers and document initialization order, exclusive
  chunk boundaries, missing-parser behavior, and the Markdown activation policy.

### 1.0.5 — 2026-10-16

#### Fixed

- Scope chunk insertion, execution, and rendering shortcuts to Markdown/Quarto
  buffers, with cleanup when the filetype changes.
- Replace tmux navigation mappings executed inside the plugin specification
  table with declared mappings, including descriptions and upstream defaults.

#### Changed

- Keep native editor-wide mappings in `config/keymaps.lua` and move Telescope,
  Neo-tree, Slime, and tmux actions into their owning plugin specifications.
- Share document mappings and chunk insertion through `config/markup.lua`,
  called by the Markdown and Quarto `after/ftplugin` files.
- Document mapping ownership, mode/scope, and explicit `:QuartoActivate` use
  for ordinary Markdown. Clarify same-language multi-cell execution.

### 1.0.4 — 2026-10-16

#### Changed

- **Persistent undo:** Consolidate setup into one documented block with a single
  directory-creation check. Derive the `undodir` location from Neovim's standard
  data path so it respects `XDG_DATA_HOME` and `NVIM_APPNAME`.

### 1.0.3 — 2026-10-16

#### Fixed

- **Autocommands:** Register the last-cursor and yank-highlight descriptions as
  autocmd metadata instead of assigning a global `desc` inside their callbacks.

#### Changed

- Clarify comments about saved cursor positions, valid buffer lines, and the
  yank-highlight autocmd's buffer scope.

### 1.0.2 — 2026-10-16

#### Fixed

- **Treesitter:** Explicitly activate source-file highlighting for Lua,
  Python, R, shell/Bash, and Vimscript. Map the `sh` filetype to the Bash parser,
  and tolerate unavailable parsers during file loading.

#### Changed

- Document parser installation, highlighting activation, independent folding,
  and the distinction from experimental Treesitter indentation.

### 1.0.1 — 2026-10-16

#### Fixed

- **Telescope:** Initialize Telescope explicitly and activate its
  installed native fzf sorter. Document the setup order and native dependency.

## 1.0.0 — 2026-10-16

### Implemented

- Record the existing Neovim configuration as the pre-refinement baseline.
