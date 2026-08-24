# my-neovim

<img src="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/neovim.png" width="150"/>

Personal Neovim config managed with [GNU Stow](https://www.gnu.org/software/stow/) and [lazy.nvim](https://github.com/folke/lazy.nvim). Leader key is `<Space>`.

<img src="https://github.com/TylerDurham/my-neovim/blob/master/img/screenshot1.png?raw=true"/>

## Installation

```shell
./install.sh
```

This symlinks the config via Stow and points `~/.config/nvim` at `~/.config/my-neovim` (backing up any existing config to `~/.config/nvim.bak`).

## Structure

```
.config/my-neovim/
├── init.lua                  # Entry point — loads config + lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua       # Vim options (tabs, line numbers, clipboard, etc.)
│   │   ├── keymaps.lua       # Global keymaps (not plugin-specific)
│   │   ├── colorscheme.lua   # Colorscheme loader
│   │   └── settings.lua      # Shared settings (e.g. alpha dashboard header)
│   └── plugins/              # One file per plugin, loaded by lazy.nvim
└── snippets/                 # Custom VSCode-style snippets (see Snippets)
```

## Plugins

| Plugin | Purpose |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Start screen / dashboard |
| [barbar.nvim](https://github.com/romgrk/barbar.nvim) | Tab / buffer bar |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer sidebar |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting & parsing |
| [mason.nvim](https://github.com/mason-org/mason.nvim) | LSP / tool installer |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client configuration |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion engine |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Code formatter |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto-close brackets & quotes |
| [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) | Inline color previews |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap) | Debug Adapter Protocol client |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) | Debugger UI (scopes, stacks, watches, repl) |
| [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) | Go / Delve adapter + test debugging |
| [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) | Inline variable values while debugging |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Keymap hints popup |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlight and search TODO comments |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics / quickfix panel |

### Colorschemes

| Plugin | Variant |
|---|---|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | `tokyonight-storm` (default) |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | |
| [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | |
| [nord.nvim](https://github.com/gbprod/nord.nvim) | |
| [onedarkpro.nvim](https://github.com/olimorris/onedarkpro.nvim) | |
| [rose-pine](https://github.com/rose-pine/neovim) | |
| [neovim-ayu](https://github.com/Shatur/neovim-ayu) | |

### LSP servers (auto-installed via Mason)

- `gopls` — Go
- `lua_ls` — Lua
- `cssls` — CSS
- `emmet_language_server` — HTML / CSS / JSX
- `templ` — Templ
- `just-lsp` — Justfile
- `nixd` — Nix (system-managed, not Mason — install via nix)

### Formatters / tools (auto-installed via Mason)

- `delve` — Go debugger (`dlv`, used by nvim-dap-go)
- `prettier` — CSS, HTML, JavaScript, TypeScript
- `shfmt` — Shell formatting
- `tree-sitter-cli` — required by nvim-treesitter to build parsers
- `stylua` — Lua formatting (system-managed, not Mason)
- `gofumpt`, `goimports` — Go formatting (system-managed, not Mason)
- `nixfmt` — Nix formatting (system-managed, not Mason — install via nix)

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
| `<leader>fm` | n | Format current buffer (conform) |
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
| `<leader>d` | n/v | Delete to black-hole register (no yank) — debug keymaps use `<leader>D` so they don't shadow this |

### Buffers (barbar)

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | n/v | Next buffer |
| `<S-Tab>` | n/v | Previous buffer |
| `<leader>q` | n/v | Close current buffer |
| `<leader>qb` | n/v | Close all buffers but current |
| `<leader>qr` | n/v | Close all buffers to the right |
| `<leader>ql` | n/v | Close all buffers to the left |

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
| `<leader>fn` | n/v | Find neovim config files |
| `<leader>fw` | n/v | Live grep |
| `<leader>fk` | n/v | Browse keymaps |
| `<leader>ft` | n/v | Find TODO comments |
| `<leader>th` | n/v | Select colorscheme (Telescope picker) |

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

### Snippets

Custom snippets live in `.config/my-neovim/snippets/` in [VSCode snippet format](https://code.visualstudio.com/docs/editor/userdefinedsnippets),
loaded by blink.cmp's `snippets` source alongside [friendly-snippets](https://github.com/rafamadriz/friendly-snippets).
Type the prefix, then `<Tab>`/`<CR>` to expand.

| Language | Prefixes | Reference |
|---|---|---|
| Shell (`sh`, `bash`, `zsh`) | `shebang`, `logging`, `usage`, `getopts`, `args` | [docs/shell.md](docs/shell.md) |
| Go | `iferr`, `errsent`, `ctxto`, `defclose`, `tt`, `bench`, `mainctx`, `httpsrv`, `workers` | [docs/go.md](docs/go.md) |

#### Adding a snippet

1. Add the snippet to an existing file in `snippets/` (e.g. `shell.json`), or create a new
   `<language>.json` file.
2. If you created a new file, register it under `contributes.snippets` in `snippets/package.json`
   with its `language` list.
3. Document it in the matching `docs/<language>.md` (create one and add a row to the table
   above if the language is new).
4. Restart Neovim — snippet files are read at startup.

### LSP

| Key | Mode | Action |
|---|---|---|
| `K` | n | Hover documentation |
| `<C-k>` | n | Signature help (function args) |
| `<leader>rn` | n | Rename symbol |
| `gd` | n | Go to definition |

### Debugging (nvim-dap)

Go debugging is wired up out of the box — Delve (`dlv`) is installed by Mason, and `nvim-dap-go`
registers the Go adapter plus the standard *debug package* / *debug test* / *attach* configurations.
Press `<F5>` in a Go file to start; the UI panels open and close with the session.

| Key | Mode | Action |
|---|---|---|
| `<F5>` | n | Continue / start session |
| `<S-F5>` | n | Terminate session |
| `<F9>` | n | Toggle breakpoint |
| `<F10>` | n | Step over |
| `<F11>` | n | Step into |
| `<S-F11>` | n | Step out |
| `<leader>b` | n | Toggle breakpoint |
| `<leader>B` | n | Conditional breakpoint (prompts for expression) |
| `<leader>Du` | n | Toggle debugger UI |
| `<leader>De` | n/v | Evaluate expression under cursor / selection |
| `<leader>Dr` | n | Toggle debug REPL |
| `<leader>Dl` | n | Run last configuration |
| `<leader>Dc` | n | Run to cursor |
| `<leader>Dt` | n | Debug nearest Go test |
| `<leader>DT` | n | Debug last Go test |

Delve builds with `go build`, so the debug target must live inside a Go module — run
`go mod init <name>` first if the directory has no `go.mod`.

> Debug actions use `<leader>D` (capital) rather than `<leader>d`, which is taken by
> delete-without-yanking — using it as a prefix would break `dt{char}`-style motions.

### TODO Comments

| Key | Mode | Action |
|---|---|---|
| `]t` | n | Jump to next TODO comment |
| `[t` | n | Jump to previous TODO comment |

### Diagnostics (trouble.nvim)

| Key | Mode | Action |
|---|---|---|
| `<leader>xx` | n | Toggle workspace diagnostics |
| `<leader>xX` | n | Toggle buffer diagnostics |
| `<leader>xt` | n | Toggle TODO list |
| `<leader>xL` | n | Toggle location list |
| `<leader>xQ` | n | Toggle quickfix list |
| `<leader>cs` | n | Toggle symbols panel |
| `<leader>cl` | n | Toggle LSP definitions / references |

## Scripts

| Script | Purpose |
|---|---|
| `./install.sh` | Stow config and symlink as `~/.config/nvim` |
| `./clean.sh` | Remove Neovim state (plugins, cache, etc.) |
