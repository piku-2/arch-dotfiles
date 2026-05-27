#!/usr/bin/env bash
set -euo pipefail

css="${1:-$HOME/.config/waybar/colors.css}"
out="${2:-$HOME/.config/fzf/colors.sh}"

css_get() {
  local name="$1"
  awk -v n="$name" '$1=="@define-color" && $2==n { gsub(/;/,"",$3); print $3; exit }' "$css"
}

if [ ! -f "$css" ]; then
  exit 0
fi

primary=$(css_get primary || true)
surface=$(css_get surface || true)
surface_dim=$(css_get surface_dim || true)
on_surface=$(css_get on_surface || true)
outline=$(css_get outline || true)
error=$(css_get error || true)

# Best-effort fallback to avoid generating an invalid file
: "${primary:=#cba6f7}"
: "${surface:=#1e1e2e}"
: "${surface_dim:=#181825}"
: "${on_surface:=#cdd6f4}"
: "${outline:=#585b70}"
: "${error:=#f38ba8}"

fzf_color="bg:${surface},bg+:${surface_dim},fg:${on_surface},fg+:${on_surface},hl:${error},hl+:${error},prompt:${primary},pointer:${primary},marker:${primary},border:${outline}"

cat >"$out" <<EOF
# Generated from: $css
export FZF_COLOR='$fzf_color'
EOF
