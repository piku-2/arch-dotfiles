#!/bin/bash

update_monitors() {
  # 内蔵ディスプレイ（eDP-*）以外を外部モニターとして扱う
  external_monitors=$(hyprctl monitors -j | jq -r '.[] | select(.name | startswith("eDP-") | not) | .name')
  external_count=$(echo "$external_monitors" | grep -c .)

  if [ "$external_count" -gt 0 ]; then
    # 外部モニターがあれば: 内蔵を無効化
    hyprctl keyword monitor "eDP-1,disable"
  else
    # 外部モニターがなければ: 内蔵を有効化
    hyprctl keyword monitor "eDP-1,preferred,auto,auto"
    sleep 1 # モニター有効化を待つ
  fi

  # 壁紙は切り替えない。必要なら「今の壁紙」を各出力に復元する。
  awww restore >/dev/null 2>&1 || true
}

handle() {
  case $1 in
  monitoradded* | monitorremoved*)
    sleep 1 # モニター状態の安定を待つ
    update_monitors
    ;;
  esac
}

until awww query >/dev/null 2>&1; do
  sleep 0.5
done

# 起動時に1回判定
update_monitors

# その後イベント監視
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
