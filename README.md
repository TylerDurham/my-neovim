# my-neovim

<img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/neovim.png" width="150"/>

Personal Neovim config managed with [GNU Stow](https://www.gnu.org/software/stow/) and [lazy.nvim](https://github.com/folke/lazy.nvim). Leader key is `<Space>`.

## Installation

```shell
./install.sh
```

This symlinks the config via Stow and points `~/.config/nvim` at `~/.config/my-neovim` (backing up any existing config to `~/.config/nvim.bak`).

## Structure

```
.config/my-neovim/
├── init.lua                  # Entry point — loads config + lazy.nvim
└── lua/
    ├── config/
    │   ├── options.lua       # Vim options (tabs, line numbers, clipboard, etc.)
    │   ├── keymaps.lua       # Global keymaps (not plugin-specific)
    │   ├── colorscheme.lua   # Colorscheme loader
    │   └── settings.lua      # Shared settings (e.g. alpha dashboard header)
    └── plugins/              # One file per plugin, loaded by lazy.nvim
```

## Plugins

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [tokyo-night](https://github.com/folke/tokyonight.nvim) | Colorscheme |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Start screen / dashboard |
| [barbar.nvim](https://github.com/romgrk/barbar.nvim) | Tab / buffer bar |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer sidebar |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & parsing |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP / tool installer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets & quotes |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap hints popup |

### LSP servers (auto-installed via Mason)

- `gopls` — Go
- `lua_ls` — Lua

### Formatters / tools (auto-installed via Mason)

- `gofumpt`, `goimports` — Go formatting
- `shfmt` — Shell formatting
- `stylua` — Lua formatting

## Colorscheme

Theme selection is persistent — the active colorscheme is saved to `~/.local/share/nvim/saved_colorscheme.txt` and restored on every startup. The default fallback is `tokyonight-storm`.

To switch themes interactively, use the `:ThemeSelect` command (or the `t` button on the dashboard). This opens a Telescope fuzzy picker over all installed colorschemes; confirming a selection applies and saves it immediately.

## Dashboard (alpha-nvim)

The start screen is shown when Neovim is opened with no file argument.

| Key | Action |
|---|---|
| `c` | New file |
| `f` | Find file (Telescope) |
| `g` | Find text (live grep) |
| `n` | Open `init.lua` config |
| `r` | Recent files |
| `t` | Change theme (ThemeSelect picker) |
| `q` | Quit |

## Keymaps

### General

| Key | Mode | Action |
|---|---|---|
| `<leader>?` | n | Show all keymaps (which-key) |
| `<leader>qq` | n/v | Quit all |
| `jj` | i | Escape to normal mode |
| `<leader>tn` | n | Cycle line number mode (hybrid → absolute → off) |
| `<leader>X` | n | `chmod +x` current file |
| `<leader>ga` | n | `git add` current file |

### Clipboard & registers

| Key | Mode | Action |
|---|---|---|
| `y` | v | Yank and keep cursor in place |
| `p` | v | Paste without overwriting yank register |
| `<leader>y` | n/v | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |
| `<leader>p` | n/v | Paste from system clipboard |
| `<leader>P` | n/v | Paste before from system clipboard |
| `<leader>d` | n/v | Delete to black-hole register (no yank) |

### Buffers (barbar)

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | n/v | Next buffer |
| `<S-Tab>` | n/v | Previous buffer |
| `<leader>x` | n/v | Close current buffer |

### File explorer (neo-tree)

| Key | Mode | Action |
|---|---|---|
| `<leader>ee` | n | Toggle neo-tree |
| `<leader>ef` | n | Focus neo-tree |
| `<leader>er` | n | Reveal current file in neo-tree |
| `<leader>eg` | n | Git status (floating) |

### Telescope (fuzzy finder)

| Key | Mode | Action |
|---|---|---|
| `<leader>ff` | n/v | Find files (including hidden) |
| `<leader>fa` | n/v | Find files |
| `<leader>fw` | n/v | Live grep |
| `<leader>fk` | n/v | Browse keymaps |

#### Telescope picker keymaps

| Key | Mode | Action |
|---|---|---|
| `<C-j>` / `<C-k>` | insert | Move selection down / up |
| `<C-d>` / `<C-u>` | insert | Scroll preview down / up |
| `j` / `k` | normal | Move selection down / up |
| `gg` / `G` | normal | Jump to top / bottom |
| `q` | normal | Close picker |

### Completion (blink.cmp)

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Select next / previous item |
| `<CR>` | Accept selection |
| `<C-Space>` | Open menu or docs |
| `<C-e>` | Hide menu |

## Scripts

| Script | Purpose |
|---|---|
| `./install.sh` | Stow config and symlink as `~/.config/nvim` |
| `./clean.sh` | Remove Neovim state (plugins, cache, etc.) |
