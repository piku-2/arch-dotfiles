#!/bin/bash

# 現在の電源供給状態をチェック (1: 充電中, 0: バッテリー)
if [ -f /sys/class/power_supply/AC/online ]; then
  STATUS=$(cat /sys/class/power_supply/AC/online)
elif [ -f /sys/class/power_supply/ADP1/online ]; then
  STATUS=$(cat /sys/class/power_supply/ADP1/online)
else
  exit 0
fi

if [ "$STATUS" = "1" ]; then
  # 充電中 -> フルパワー (絶対パスに修正)
  /usr/bin/powerprofilesctl set performance
else
  # バッテリー駆動 -> バランス (絶対パスに修正)
  /usr/bin/powerprofilesctl set balanced
fi
