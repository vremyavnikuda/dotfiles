# Neovim Keybindings

## Navigation and Files

| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files with split-direction selection |
| `<leader>fg` | Live grep across project files |
| `<leader>fb` | Switch buffers |
| `<leader>fh` | Search help tags |
| `<leader>t` | Open Telescope menu |
| `<leader>nn` | Create a new file |
| `<leader>fd` | Delete current file (with confirmation) |

### Extra controls in file search (`<leader>ff`)

- `Enter` - open in current window
- `h` - open in horizontal split
- `v` - open in vertical split
- `l` - open on the left
- `j` - open at the bottom
- `n` - create a new file
- `d` - delete file

## File Tree

| Key | Description |
|-----|-------------|
| `<leader>e` | Focus file tree (if no buffer-local LSP mapping overrides it) |
| `<leader>E` | Toggle file tree |
| `Enter` | Open file in current window |
| `Alt+Enter` | Open in horizontal split |
| `Ctrl+Enter` | Open in vertical split |

## Code Navigation

| Key | Description |
|-----|-------------|
| `<leader>sf` | Search in current file |
| `<leader>sg` | Search word under cursor |
| `<leader>sr` | Find references via Telescope |
| `<leader>sd` | Document symbols via Telescope |
| `<leader>sD` | Definitions via Telescope |
| `<leader>sw` | Workspace symbols via Telescope |
| `<leader>si` | Implementations via Telescope |
| `<leader>ds` | Document symbols (LSP) |
| `<leader>ws` | Workspace symbols (LSP) |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Show hover docs |

## Window Management

| Key | Description |
|-----|-------------|
| `Alt+Left` | Move to left window |
| `Alt+Right` | Move to right window |
| `Alt+Up` | Move to upper window |
| `Alt+Down` | Move to lower window |
| `<leader>ss` | Smart horizontal split |
| `<leader>vv` | Smart vertical split |
| `<leader>qc` | Close current window |
| `<leader>ar` | Equalize all windows |

## Code Actions

| Key | Description |
|-----|-------------|
| `<leader>fm` | Format current buffer |
| `<leader>rn` | Rename symbol under cursor |
| `<leader>ca` | Code actions |
| `<leader>ih` | Toggle inlay hints |
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |

## Diagnostics

| Key | Description |
|-----|-------------|
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Show diagnostic float (in LSP buffers) |
| `<leader>q` | Populate location list with diagnostics |

## Git

| Key | Description |
|-----|-------------|
| `<leader>gg` | Open Neogit |
| `<leader>nw` | Open Nvim Wrapped |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |

## Terminal

| Key | Description |
|-----|-------------|
| `Ctrl+\\` | Toggle terminal |

## Completion

| Key | Description |
|-----|-------------|
| `Ctrl+Space` | Trigger completion |
| `Enter` | Confirm completion |
| `Tab` | Next item |
| `Shift+Tab` | Previous item |
| `Ctrl+e` | Abort completion |
| `Ctrl+b` | Scroll docs up |
| `Ctrl+f` | Scroll docs down |

---

**Note:** `<leader>` is mapped to `Space`.
