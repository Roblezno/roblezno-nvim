# 🌿 roblezno-nvim

> A personalized, robust, and minimal Neovim configuration built for **Bioinformatics**, deep understanding of IDE mechanics, and seamless workflow.

[![Work in Progress](https://img.shields.io/badge/Status-Work%20in%20Progress-orange)](#)
[![Neovim](https://img.shields.io/badge/Neovim-0.9+-blue.svg)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Language-Lua-blue)](#)

## 📖 The Philosophy

### From "Black Box" to Complete Control
I started this project with the goal of understanding how an IDE truly works. Fully-fledged IDEs like VSCode are powerful, but their abstraction of language servers (LSP), syntax parsers (Treesitter), and debuggers often left me frustrated when things broke. I wanted something more minimal and raw—a setup where I have complete control, and if something fails, I know exactly *why*, where the error comes from, and how to fix it.

### The Definitive Config
After experimenting with great starter templates like Kickstart and LazyVim, and building a slightly chaotic first custom setup, `roblezno-nvim` is my definitive configuration. It strikes a balance: **minimal but not to an extreme**. It is quick and responsive while packing all the tools needed for a seamless development experience, particularly for bioinformatics workflows. This project also serves as a personal testing ground for managing a decently-sized repository with Git.

---

## ✨ Features

- 🧬 **Bioinformatics Ready**: Configured to easily manage LSPs inside virtual environments (like **Conda**) and **Docker** containers for Python and R.
- 📓 **Quarto & Markdown**: Native support for Quarto markdown files and interactive code chunks.
- 🖥️ **Multiplexer Integration**: Plays nicely with terminal multiplexers like **Tmux**, as well as Neovim's built-in terminals.
- 🌳 **Navigation & Search**: Lightning-fast fuzzy finding powered by [Telescope](https://github.com/nvim-telescope/telescope.nvim) and intuitive file exploration with [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim).
- 🌿 **Git Integration**: Seamless Git workflow directly from the editor using Lazygit.
- 🎨 **Aesthetic & Hackable**: A beautiful, easily customizable user interface (because a good-looking IDE matters).
- 🚀 **Extensible**: Easily adaptable for other programming needs, such as web app development.

---

## 🛠️ Prerequisites

Before installing, make sure you have the following tools installed on your system:

- **[Neovim](https://neovim.io/)** (>= 0.12.0 recommended)
- **[Git](https://git-scm.com/)**
- **[Ripgrep](https://github.com/BurntSushi/ripgrep)** (Required for Telescope text search)
- **[fd](https://github.com/sharkdp/fd)** (Required for Telescope file search)

---

## 📦 Installation

> **Note:** Be sure to back up your existing Neovim configuration before proceeding!

1. **Backup your current configuration:**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   mv ~/.local/share/nvim ~/.local/share/nvim.bak
   mv ~/.local/state/nvim ~/.local/state/nvim.bak
   mv ~/.cache/nvim ~/.cache/nvim.bak
   ```

**2. Clone the repository**
```{bash}
git clone [https://github.com/Roblezno/roblezno-nvim.git](https://github.com/Roblezno/roblezno-nvim.git) ~/.config/nvim
```

**3. Start NeoVim**
```{bash}
nvim
```

*The plugin manager will automatically bootstrap and install all configured plugins upon the first launch*

## 📂 Project Structure
~/.config/nvim/
├── init.lua              # Main entry point
├── lazy-lock.json        # Plugin lockfile to ensure reproducible environments
├── to_do.txt             # Project tracking and upcoming features
└── lua/                  # Core Neovim configuration and plugin specs

🤝 Contributing & Feedback
This is primarily a personal configuration, but feedback, suggestions, and tips are always welcome! Feel free to open an Issue if you see a way to optimize the code or improve the setup.

Built with ❤️ to make the terminal feel like home.
