#!/usr/bin/env sh
# Regenerate the flatwhite themes and deploy each to its ~/.config location.
#
#   ./install.sh
#
# Neovim is not copied — the repo root IS the plugin, loaded in place by your
# package manager. This script handles the apps whose themes live under
# ~/.config: kitty, fish, and bat.
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

# --- regenerate from the single source of truth ---------------------------
echo "flatwhite → regenerating from build.py"
python3 "$ROOT/build.py"

# --- deploy ---------------------------------------------------------------
# $1 = source (relative to repo root), $2 = destination directory
deploy() {
  src="$ROOT/$1"
  dir="$2"
  name="$(basename -- "$1")"
  if [ ! -f "$src" ]; then
    echo "  skip: $1 (not found)"
    return 0
  fi
  mkdir -p "$dir"
  cp "$src" "$dir/$name"
  echo "  ok: $name -> $dir"
}

echo "flatwhite → deploying"

# kitty: included via `include ./themes/flatwhite.conf`
deploy "kitty/flatwhite.conf" "$CONFIG/kitty/themes"

# fish: sourced when THEME=flatwhite (see config.fish)
deploy "fish/flatwhite.fish" "$CONFIG/fish/themes"

# bat: prefer bat's own config dir; rebuild its cache afterwards
if command -v bat >/dev/null 2>&1; then
  bat_themes="$(bat --config-dir)/themes"
else
  bat_themes="$CONFIG/bat/themes"
fi
deploy "bat/flatwhite.tmTheme" "$bat_themes"

if command -v bat >/dev/null 2>&1; then
  echo "flatwhite → rebuilding bat cache"
  bat cache --build >/dev/null
  echo "  ok: bat cache"
fi

echo "flatwhite → done. Reload kitty (ctrl+shift+F5); restart nvim / open a new fish."
