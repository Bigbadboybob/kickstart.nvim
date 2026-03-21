# Neovim Keymaps Reference

Leader key: `<Space>`

## VS Code to Neovim Translation

| VS Code | Neovim | Action |
|---------|--------|--------|
| `Ctrl+P` | `<Space>sf` | Search files |
| `Ctrl+Shift+F` | `<Space>sg` | Search in files (grep) |
| `F12` | `gd` | Go to definition |
| `Shift+F12` | `gr` | Go to references |
| `Ctrl+.` | `<Space>ca` | Code actions |
| `F2` | `<Space>rn` | Rename symbol |
| `Ctrl+`` | `<C-\>` | Toggle terminal |
| `Ctrl+B` | `<Space>t` | Toggle file tree |
| `Ctrl+Shift+E` | `<leader>gd` | Diff view |

---

## Window Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-h>` | Normal/Terminal | Move to left window |
| `<C-j>` | Normal/Terminal | Move to window below |
| `<C-k>` | Normal/Terminal | Move to window above |
| `<C-l>` | Normal/Terminal | Move to right window |
| `<C-w>s` | Normal | Split window horizontally |
| `<C-w>v` | Normal | Split window vertically |
| `<C-w>c` | Normal | Close current window |
| `<C-w>o` | Normal | Close all other windows |
| `<C-w>=` | Normal | Make all windows equal size |
| `<C-w>+` | Normal | Increase window height |
| `<C-w>-` | Normal | Decrease window height |
| `<C-w>>` | Normal | Increase window width |
| `<C-w><` | Normal | Decrease window width |

---

## File Tree (NvimTree)

| Key | Mode | Action |
|-----|------|--------|
| `<Space>t` | Normal | Toggle file tree |

### Inside File Tree

| Key | Action |
|-----|--------|
| `<CR>` or `o` | Open file/toggle folder |
| `<Tab>` | Preview file |
| `a` | Create new file/directory |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `x` | Cut file |
| `c` | Copy file |
| `p` | Paste file |
| `y` | Copy name |
| `Y` | Copy relative path |
| `gy` | Copy absolute path |
| `q` | Close tree |
| `R` | Refresh |
| `H` | Toggle hidden files |
| `I` | Toggle gitignore |
| `s` | Open in system app |
| `/` | Search files |

---

## Terminal (ToggleTerm)

| Key | Mode | Action |
|-----|------|--------|
| `<C-\>` | Normal/Terminal | Toggle terminal |
| `<Esc>` | Terminal | Exit terminal mode |
| `jk` | Terminal | Exit terminal mode |
| `<C-h/j/k/l>` | Terminal | Navigate to other windows |

---

## File Search (Telescope)

| Key | Action |
|-----|--------|
| `<Space>sf` | Search files (like Ctrl+P) |
| `<Space>sg` | Search by grep (search in files) |
| `<Space>sw` | Search current word |
| `<Space>sh` | Search help tags |
| `<Space>sd` | Search diagnostics |
| `<Space>st` | Search TODO comments |
| `<Space>/` | Fuzzy search in current buffer |
| `<Space>?` | Recently opened files |
| `<Space><Space>` | Find open buffers |

### Inside Telescope

| Key | Action |
|-----|--------|
| `<C-j>` | Next item |
| `<C-k>` | Previous item |
| `<CR>` | Select item |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<Esc>` | Close telescope |

---

## LSP (IntelliSense)

### Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references (Telescope) |
| `gI` | Go to implementation |
| `<Space>D` | Type definition |
| `<Space>ds` | Document symbols |
| `<Space>ws` | Workspace symbols |
| `K` | Hover documentation |
| `<C-k>` | Signature help (insert mode) |

### Actions

| Key | Action |
|-----|--------|
| `<Space>rn` | Rename symbol |
| `<Space>ca` | Code action |
| `<Space>f` | Format buffer (if using conform) |
| `:Format` | Format buffer (LSP) |

### Diagnostics

| Key | Action |
|-----|--------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<Space>e` | Open floating diagnostic |
| `<Space>q` | Open diagnostics list |

### Workspace

| Key | Action |
|-----|--------|
| `<Space>wa` | Add workspace folder |
| `<Space>wr` | Remove workspace folder |
| `<Space>wl` | List workspace folders |

---

## Git (Fugitive + Gitsigns + Diffview)

### Status & Commands

| Key | Action |
|-----|--------|
| `<Space>gs` | Git status (fugitive) |
| `<Space>gb` | Git blame |
| `<Space>gp` | Git push |
| `<Space>gl` | Git pull |
| `<Space>gw` | Git write (stage current file) |

### Diff View (Cursor-like experience)

| Key | Action |
|-----|--------|
| `<Space>gd` | Open diff view |
| `<Space>gh` | File history |
| `<Space>gH` | Repo history |
| `<Space>gc` | Close diff view |

### Inside Diff View

| Key | Action |
|-----|--------|
| `<Tab>` | Next file |
| `<S-Tab>` | Previous file |
| `gf` | Go to file |
| `<leader>e` | Toggle file panel |

### Inside File Panel

| Key | Action |
|-----|--------|
| `j/k` | Navigate |
| `<CR>` | Select entry |
| `s` | Stage file/hunk |
| `S` | Stage all |
| `U` | Unstage all |
| `X` | Restore/discard changes |
| `R` | Refresh |

### Hunk Operations (Gitsigns)

| Key | Action |
|-----|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `<Space>hS` | Stage buffer |
| `<Space>hu` | Undo stage hunk |
| `<Space>hR` | Reset buffer |
| `<Space>hp` | Preview hunk |
| `<Space>hb` | Blame line |
| `<Space>hd` | Diff this |
| `<Space>hD` | Diff this ~ |
| `<Space>td` | Toggle deleted lines |

---

## Diagnostics Panel (Trouble)

| Key | Action |
|-----|--------|
| `<Space>xx` | Toggle all diagnostics |
| `<Space>xX` | Buffer diagnostics only |
| `<Space>cs` | Symbols |
| `<Space>xL` | Location list |
| `<Space>xQ` | Quickfix list |

---

## Editing

### Comments

| Key | Mode | Action |
|-----|------|--------|
| `gc` | Normal | Comment line |
| `gc` | Visual | Comment selection |
| `gcc` | Normal | Comment current line |
| `gcb` | Normal | Block comment |

### Text Objects (Treesitter)

| Key | Mode | Action |
|-----|------|--------|
| `af` | Visual/Operator | Around function |
| `if` | Visual/Operator | Inside function |
| `ac` | Visual/Operator | Around class |
| `ic` | Visual/Operator | Inside class |
| `aa` | Visual/Operator | Around parameter |
| `ia` | Visual/Operator | Inside parameter |
| `ih` | Visual/Operator | Inside git hunk |

### Movement (Treesitter)

| Key | Action |
|-----|--------|
| `]m` | Next function start |
| `[m` | Previous function start |
| `]M` | Next function end |
| `[M` | Previous function end |
| `]]` | Next class start |
| `[[` | Previous class start |
| `][` | Next class end |
| `[]` | Previous class end |
| `]t` | Next TODO comment |
| `[t` | Previous TODO comment |

### Selection (Treesitter)

| Key | Action |
|-----|--------|
| `<C-Space>` | Start/expand selection |
| `<M-Space>` | Shrink selection |
| `<C-s>` | Scope incremental |

### Swap Parameters

| Key | Action |
|-----|--------|
| `<Space>a` | Swap next parameter |
| `<Space>A` | Swap previous parameter |

---

## Completion (nvim-cmp)

| Key | Mode | Action |
|-----|------|--------|
| `<C-Space>` | Insert | Trigger completion |
| `<CR>` | Insert | Confirm selection |
| `<M-j>` | Insert | Next item |
| `<M-k>` | Insert | Previous item |
| `<C-d>` | Insert | Scroll docs down |
| `<C-f>` | Insert | Scroll docs up |
| `<Tab>` | Insert | Next snippet placeholder |
| `<S-Tab>` | Insert | Previous snippet placeholder |

---

## Jump List (Navigation History)

| Key | Action |
|-----|--------|
| `<C-o>` | Go back to previous cursor position |
| `<C-i>` | Go forward to next cursor position |
| `:jumps` | Show jump list |

---

## Misc

| Key | Action |
|-----|--------|
| `<Space>` | Leader key |
| `j/k` | Move by display lines (respects word wrap) |
| `:FormatToggle` | Toggle format on save |
| `:checkhealth` | Check configuration |
| `:Lazy` | Open plugin manager |
| `:Mason` | Open LSP installer |
