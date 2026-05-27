#!/usr/bin/env bash
set -euo pipefail

command="${1:-start}"

has() {
  command -v "$1" >/dev/null 2>&1
}

start_swaync() {
  has swaync || exit 0
  pgrep -x swaync >/dev/null 2>&1 && exit 0
  swaync >/dev/null 2>&1 &
}

case "$command" in
  start)
    start_swaync
    ;;
  toggle)
    has swaync-client || exit 0
    if ! pgrep -x swaync >/dev/null 2>&1; then
      start_swaync
      sleep 0.2
    fi
    swaync-client -t >/dev/null 2>&1 || true
    ;;
  reload)
    has swaync-client || exit 0
    swaync-client --reload-config >/dev/null 2>&1 || true
    swaync-client --reload-css >/dev/null 2>&1 || true
    ;;
  *)
    printf 'Usage: %s [start|toggle|reload]\n' "$0" >&2
    exit 2
    ;;
esac
