# dotfiles

My personal dotfiles for macOS, managed as a plain folder with a symlink install script.

## What's here

| Path | Description |
|------|-------------|
| `.zshrc` | Zsh config — Oh My Zsh, git/kubectl aliases, a `tm` tmux project launcher |
| `.tmux.conf` | tmux config — vim-style panes, mouse, custom status bar |
| `.hammerspoon/` | [Hammerspoon](https://www.hammerspoon.org/) automation (`init.lua`) |
| `.config/nvim/` | Neovim config (LazyVim) |
| `.config/git/` | Global git `ignore` |

## Install

```sh
git clone https://github.com/mennahouta/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks each tracked file into `$HOME`. Any existing file is backed
up to `<name>.bak.<timestamp>` first, so it's safe to run on a machine that
already has configs. Re-running is idempotent.

## Adding a new dotfile

1. Move the file into this repo, preserving its path relative to `$HOME`
   (e.g. `~/.config/foo/bar` → `~/dotfiles/.config/foo/bar`).
2. Add its `$HOME`-relative path to the `FILES` array in `install.sh`.
3. Run `./install.sh` to link it, then commit.

## Not tracked

Secrets and machine-local state are intentionally excluded: `.ssh`, cloud
credentials (`.boto`, `.gsutil`, `.config/gcloud`), `.config/gh` (OAuth token),
`.kube`, `.docker`, shell history, and caches.
