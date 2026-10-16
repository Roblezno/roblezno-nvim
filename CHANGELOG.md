# Changelog

`VERSION` records the current configuration version. Each completed refinement
step increments the patch version; merge commits do not increment it again.
Changes accumulate under Unreleased until the completed refinement is summarized
as version 1.1.0.

## Unreleased

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
