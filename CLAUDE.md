# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on kickstart.nvim. It uses lazy.nvim as the plugin manager with a modular structure separating core config from custom additions.

## Architecture

- `init.lua` - Main configuration: plugin declarations, editor options, keymaps, LSP setup, treesitter, telescope, completion
- `lua/custom/plugins/` - User customizations (auto-imported via lazy.nvim)
  - `init.lua` - Window navigation keymaps, auto-close logic for NvimTree/ToggleTerm
  - `filetree.lua` - NvimTree setup, opens on VimEnter
  - `terminal.lua` - ToggleTerm setup with terminal keymaps
  - `markdown.lua` - render-markdown.nvim (`<Space>md` toggles rendering)
- `lua/custom/md_table_wrap.lua` - render-markdown custom handler: redraws tables wider than the window with word-wrapped cells (not in `plugins/`, since that dir is auto-imported as lazy specs)
- `lua/kickstart/plugins/autoformat.lua` - LSP format-on-save (disabled by default, toggle with `:FormatToggle`)
- `pager.lua` - Separate minimal config for Kitty scrollback pager

## Key Keymaps

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `<C-h/j/k/l>` | Window navigation (normal and terminal modes) |
| `<C-\>` | Toggle terminal |
| `<Space>t` | Toggle NvimTree |
| `<Space>sf` | Search files (Telescope) |
| `<Space>sg` | Search by grep (Telescope) |
| `<Space>/` | Fuzzy search current buffer |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<Space>rn` | Rename symbol |
| `<Space>ca` | Code action |
| `[d` / `]d` | Previous/next diagnostic |
| `gc` | Comment (visual/line) |
| `<C-Space>` | Treesitter incremental selection |
| `<M-j>` / `<M-k>` | Navigate completion menu |

## Treesitter Text Objects

- `af`/`if` - Outer/inner function
- `ac`/`ic` - Outer/inner class
- `aa`/`ia` - Outer/inner parameter
- `]m`/`[m` - Next/previous function start
- `]]`/`[[` - Next/previous class start

## LSP Configuration

Language servers are managed via mason.nvim. Currently configured:
- `lua_ls` - Lua (with neodev.nvim for Neovim API)
- `pylsp` - Python (with flake8 config, 2-space indent)

Add new servers to the `servers` table in init.lua (around line 481).

## Code Style

Lua formatting uses stylua with:
- 160 column width
- 2-space indentation
- Single quotes preferred
- No call parentheses

## Adding Custom Plugins

Create a new file in `lua/custom/plugins/` returning a lazy.nvim plugin spec table. Files in this directory are auto-imported.
