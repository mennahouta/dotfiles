#!/usr/bin/env bash
#
# install.sh — symlink the tracked dotfiles into $HOME.
#
# Each managed path is linked from this repo into its location under $HOME.
# Any existing real file/dir at the destination is backed up to "<name>.bak.<ts>"
# before the symlink is created. Re-running is safe (idempotent).

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Paths to link, relative to both the repo root and $HOME.
FILES=(
  .zshrc
  .tmux.conf
  .hammerspoon
  .config/nvim
  .config/git
)

for f in "${FILES[@]}"; do
  src="$DOTFILES/$f"
  dest="$HOME/$f"

  if [ ! -e "$src" ]; then
    echo "skip (not in repo): $f"
    continue
  fi

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    # Already a symlink — replace it (points may have changed).
    rm "$dest"
  elif [ -e "$dest" ]; then
    backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dest" "$backup"
    echo "backed up: $dest -> $backup"
  fi

  ln -s "$src" "$dest"
  echo "linked:    $dest -> $src"
done

echo "Done. Restart your shell or run: source ~/.zshrc"
