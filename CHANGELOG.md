# Changelog

`VERSION` records the latest released configuration version. Versions follow
[Semantic Versioning](https://semver.org) in its `0.y.z` initial-development
form: a minor bump (`0.2.0` → `0.3.0`) for new workflows or behavior changes,
and a patch bump (`0.2.0` → `0.2.1`) for fixes and documentation. Each release
is tagged `vX.Y.Z` on `main`.

Work merged into `dev` is recorded under **Unreleased**. At release time, that
section receives its version and date, `VERSION` is updated, and `main` is
tagged.

**Numbering before 2026-10-20:** earlier tags, commit messages, and the local
implementation plan used a `1.x`/`2.x` scheme. They map to the current numbers
as follows:

| Old | Current |
| --- | --- |
| `1.0.0` (baseline) | `0.1.0` |
| `1.0.1`–`1.0.10` (refinement steps) | Development of `0.2.0` |
| `2.0.0` (refinement release) | `0.2.0` |
| `2.0.1` (visual follow-up) | `0.2.1` |
| `2.1.0` (planned Gitsigns) | `0.3.0` |

## Unreleased

### Fixed

- Lualine uses its default section separators; the custom separator glyphs are
  disabled.

### Deleted

- The README's "Versioning and branches" section. The versioning rules remain
  at the top of this changelog.

### Changed

- Documentation update for this version's project scope: the README overview
  now describes the project's goals and current status.

## 0.2.0 — 2026-10-17

Consolidates refinement steps 1–8 and 10. Their commit messages carry the old
intermediate numbers `1.0.1`–`1.0.8` and `1.0.10`; step 9 (Gitsigns) was
deferred, so `1.0.9` does not exist.

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

## 0.1.0 — 2026-10-16

### Implemented

- Record the existing Neovim configuration as the pre-refinement baseline.
