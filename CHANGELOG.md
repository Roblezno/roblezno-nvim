# Changelog

`VERSION` records the current configuration version. Dated entries summarize
completed releases; intermediate refinement milestones remain in Git history.

**Planned work:** Gitsigns is reserved for version `2.1.0` and is **on hold**.

## Unreleased

## 2.0.0 — 2026-10-17

Consolidates refinement steps 1–8 and 10, recorded during development as
`1.0.1`–`1.0.8` and `1.0.10`. Step 9 was deferred, so `1.0.9` was skipped.

### Implemented

- Which-key group labels and Telescope shortcuts for recent files, cursor-word
  search, help tags, and keymaps.
- Buffer-local Quarto preview and close-preview shortcuts for Markdown/Quarto.
- Manual native LSP source formatting: Ruff for Python and one selected provider
  for other source buffers, with a picker when several clients qualify.
- An on-demand shortcut for Neovim's bundled undo-tree viewer.

### Fixed

- Initialize Telescope and activate the installed native fzf sorter.
- Explicitly start source highlighting for Lua, Python, R, shell/Bash, and
  Vimscript, including the `sh`-to-`bash` parser mapping and missing-parser handling.
- Register last-cursor and yank-highlight descriptions as autocmd metadata.
- Declare tmux navigation mappings correctly and scope document insertion,
  execution, and rendering shortcuts to Markdown/Quarto with filetype cleanup.

### Changed

- Separate native, plugin-wide, and buffer-local mapping ownership. Share
  document mappings and chunk insertion in `config/markup.lua`.
- Centralize document events, Otter language discovery/reactivation, diagnostic
  cleanup, and Noice popup policy in `config/quarto.lua`; keep syntax detection
  in `config/prose.lua` and plugin options in their specifications.
- Preserve automatic Quarto activation and make ordinary Markdown activation
  explicit through `:QuartoActivate`, including reactivation for new languages.
- Load Telescope through picker keys/commands and Quarto through its filetype
  or commands, with document guards initialized before plugin activation.
- Consolidate persistent undo setup around Neovim's standard data directory.
- Document startup, ownership, pinned requirements, language support including
  Nextflow and external R, analysis/execution environments, native syntax
  selection, and plugin restoration/updates. Correct module comments and add
  upstream links while retaining labeled inactive customization examples.

Verification consisted of source/documentation review and Git whitespace
checks. Tests, headless Neovim, health checks, and profiling were not run.

## 1.0.0 — 2026-10-16

### Implemented

- Record the existing Neovim configuration as the pre-refinement baseline.
