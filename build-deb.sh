#!/bin/bash
# ============================================================
#  智能终端 .deb 打包脚本 (Ubuntu ARM64)
# ============================================================
#
# 使用方法:
#   chmod +x build-deb.sh
#   ./build-deb.sh
#
# 前提条件:
#   - Ubuntu/Debian ARM64 系统
#   - 已安装 Node.js 18+
#   - 已安装 dpkg-dev, fakeroot
#

set -e

echo "=========================================="
echo "  智能终端 .deb 打包工具"
echo "  目标平台: Ubuntu ARM64"
echo "=========================================="

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ---- 1. 环境检查 ----
echo ""
echo -e "${YELLOW}[1/5] 检查环境...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}错误: 未找到 Node.js，请先安装${NC}"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'.' -f1 | tr -d 'v')
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}错误: Node.js 版本过低，需要 18+，当前: $(node -v)${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node -v)${NC}"

ARCH=$(uname -m)
if [ "$ARCH" != "aarch64" ]; then
    echo -e "${YELLOW}⚠ 当前架构: $ARCH (目标为 arm64/aarch64)${NC}"
    echo "  如果在 x86_64 上交叉编译，需使用 docker 或 QEMU"
fi
echo -e "${GREEN}✓ 架构: $ARCH${NC}"

# ---- 2. 安装依赖 ----
echo ""
echo -e "${YELLOW}[2/5] 安装 npm 依赖...${NC}"
npm install --legacy-peer-deps
echo -e "${GREEN}✓ 依赖安装完成${NC}"

# ---- 3. 赋予构建脚本执行权限 ----
echo ""
echo -e "${YELLOW}[3/5] 准备构建资源...${NC}"
chmod +x build/after-install.sh build/after-remove.sh 2>/dev/null || true
mkdir -p build/icons

# 复制 SVG 图标到构建目录（electron-builder 会自动处理）
if [ -f icons/icon.svg ]; then
    cp icons/icon.svg build/icons/icon.png 2>/dev/null || true
fi
echo -e "${GREEN}✓ 构建资源就绪${NC}"

# ---- 4. 执行打包 ----
echo ""
echo -e "${YELLOW}[4/5] 开始打包 .deb ...${NC}"
npx electron-builder --linux deb --arm64 --publish never

# ---- 5. 输出结果 ----
echo ""
echo -e "${YELLOW}[5/5] 检查产物...${NC}"

DEB_FILE=$(find dist/*.deb 2>/dev/null | head -1)
if [ -n "$DEB_FILE" ]; then
    SIZE=$(du -h "$DEB_FILE" | cut -f1)
    echo ""
    echo -e "${GREEN}=========================================="
    echo "  ✅ 打包成功！"
    echo "==========================================${NC}"
    echo -e "  文件: ${DEB_FILE}"
    echo -e "  大小: ${SIZE}"
    echo ""
    echo "  安装命令:"
    echo "    sudo dpkg -i $DEB_FILE"
    echo "    sudo apt-get install -f  # 解决依赖"
    echo ""
    echo "  运行方式:"
    echo "    启动器 → 智能终端"
    echo "    或执行: trtc-terminal"
else
    echo -e "${RED}未找到 .deb 文件，打包可能失败${NC}"
    echo "请查看上方日志排查问题"
    exit 1
fi
