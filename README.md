# Neovim Configuration

A minimal, fast, and opinionated Neovim configuration focused on **clarity, performance, and modern Neovim features**.

This setup is tailored primarily for **Go and protobuf development**, while staying close to upstream Neovim (≥ 0.11) and avoiding unnecessary abstraction.

## ✨ Features

- Native **Neovim LSP** configuration (no wrappers)
- **gopls** and **lua_ls** out of the box
- **nvim-cmp** for completion (LSP, buffer, path, snippets)
- **Treesitter** for syntax highlighting & indentation
- **Telescope** for fuzzy finding
- **nvim-tree** for file navigation
- Async **quickfix command runner** (`:Grep`, `:Make`, `:Term`)
- Custom **theme engine** (dark & light)
- **lazy.nvim** for efficient, predictable plugin loading

## 📁 Directory Structure

```text
~/.config/nvim
├── init.lua
├── lazy-lock.json
└── lua/paulpaule21
    ├── core
    │   ├── init.lua
    │   ├── options.lua
    │   └── keymaps.lua
    ├── plugins
    │   ├── lsp
    │   ├── nvim-cmp.lua
    │   ├── nvim-tree.lua
    │   ├── telescope.lua
    │   ├── treesitter.lua
    │   └── lualine.lua
    ├── theme
    │   └── init.lua
    └── qfexec.lua
```

## Installation
```sh
git  clone https://github.com/paulpaule21/nvim.git ~/.config/nvim
```

Then start Neovim:
```sh
nvim
```

**NOTE: Plugins are installed automatically on first launch.**

## Keybindings (Highlights)
Leader key: space
```text
<leader>ff — Find files
<leader>fs — Live grep
<leader>gd — Go to definition
<leader>gi — Go to implementation
<leader>ca — Code actions
<leader>ee — Toggle file tree
```

## Design Philosophy
- Prefer built-in Neovim functionality over heavy plugin frameworks
- Keep configuration explicit and readable
- Avoid hidden magic and global side effects
- Optimize for startup time and maintainability
- Treat Neovim as a programmable editor, not an IDE clone

## Contributions
- This repository is published as a personal reference.
- Pull requests and issues are intentionally disabled
- The configuration reflects personal preferences
- Feel free to fork and adapt it for your own use

