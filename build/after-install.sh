#!/bin/bash
# after-install.sh - 安装后执行的脚本

# 创建桌面快捷方式
if [ "$1" = "configure" ] || [ -z "$1" ]; then
  # 更新桌面数据库
  if command -v update-desktop-database &> /dev/null; then
    update-desktop-database -q /usr/share/applications 2>/dev/null || true
  fi
  
  # 刷新图标缓存
  if command -v gtk-update-icon-cache &> /dev/null; then
    gtk-update-icon-cache -q /usr/share/icons/hicolor 2>/dev/null || true
  fi
fi

exit 0
