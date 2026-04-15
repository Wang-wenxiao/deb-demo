# 智能终端 - 桌面应用

将 TRTC 智能终端 Web 应用打包为 **Ubuntu ARM64** 原生 `.deb` 安装程序。

## 📦 产物信息

| 项目 | 说明 |
|------|------|
| 应用名称 | 智能终端 (trtc-terminal) |
| 目标平台 | Ubuntu / Debian ARM64 (aarch64) |
| 打包格式 | .deb |
| 运行时 | Electron 28 |
| 加载 URL | `https://kh.tyzfchina.com.cn:4433/` |

## 🚀 快速开始

### 环境要求

```bash
# 必须在 ARM64 Ubuntu/Debian 上执行
uname -m  # 应输出: aarch64

# 安装构建依赖
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    libgtk-3-dev \
    libnotify-dev \
    libnss3-dev \
    libxss1 \
    libxtst6 \
    xdg-utils \
    libatspi2.0-0 \
    libsecret-1-dev \
    dpkg-dev \
    fakeroot \
    rpm

# Node.js 18+
node -v   # 需要 >= 18
npm -v
```

### 打包步骤

```bash
# 1. 进入项目目录
cd trtc-desktop-app

# 2. 赋予脚本权限
chmod +x build-deb.sh build/after-install.sh build/after-remove.sh

# 3. 一键打包
./build-deb.sh
```

### 手动打包（可选）

```bash
# 如果需要更多控制，可分步执行：
npm install --legacy-peer-deps
npx electron-builder --linux deb --arm64 --publish never
```

产物位置：`dist/trtc-terminal_1.0.0_arm64.deb`

## 📋 安装与使用

### 在目标机器上安装

```bash
# 方式一：dpkg 直接安装（推荐）
sudo dpkg -i dist/trtc-terminal_1.0.0_arm64.deb

# 如有未满足的依赖，运行：
sudo apt-get install -f

# 方式二：apt 自动处理依赖
sudo apt install ./dist/trtc-terminal_1.0.0_arm64.deb
```

### 启动应用

- **图形界面**：应用启动器 → 搜索"智能终端"
- **命令行**：`trtc-terminal`
- **桌面**：自动生成 `.desktop` 快捷方式

### 卸载

```bash
sudo apt remove trtc-terminal
# 或完全清除配置：
sudo apt purge trtc-terminal
```

## 🏗 项目结构

```
trtc-desktop-app/
├── package.json          # 项目配置 + electron-builder 配置
├── main.js               # Electron 主进程入口
├── preload.js            # 预加载脚本（安全 API 桥接）
├── build-deb.sh          # 一键打包脚本
├── icons/
│   └── icon.svg          # 应用图标源文件
└── build/
    ├── after-install.sh  # 安装后钩子脚本
    └── after-remove.sh   # 卸载后钩子脚本
```

## ⚙️ 关键配置说明

### deb 包元数据 (`package.json` → `build.linux.desktop`)

| 字段 | 值 | 说明 |
|------|-----|------|
| Name | 智能终端 | 显示名称 |
| Comment | TRTC 音视频通话系统 | 应用描述 |
| Categories | Utility;Network;AudioVideo | 分类标签 |
| StartupWMClass | trtc-terminal | 窗口管理标识 |

### 系统依赖 (`build.deb.depends`)

```
libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, 
xdg-utils, libatspi2.0-0, libsecret-1-0
```

这些是 Electron 在 Linux 上运行的必要系统库。

## 🔧 自定义修改

### 修改加载的 URL

编辑 `main.js` 第 5 行：

```javascript
const APP_URL = 'https://your-custom-url.com';
```

### 修改应用名称/版本

编辑 `package.json` 的 `name`、`version`、`productName` 字段。

### 替换图标

将 PNG 图标放入 `icons/icon.png`（建议 256×256 或 512×512），或替换 `icons/icon.svg` 后重新打包。

### 调整窗口大小

编辑 `main.js` 中 `BrowserWindow` 构造参数：

```javascript
new BrowserWindow({
  width: 1440,     // 宽度
  height: 900,     // 高度
  // ...
});
```

## 🐛 常见问题

**Q: 提示 "command not found: node"？**
→ 安装 Node.js：`curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt install -y nodejs`

**Q: 当前是 x86_64 系统，如何交叉编译？**
→ 推荐使用 Docker + QEMU：
```bash
docker run --rm -it -v $(pwd):/app -w /app \
    multiarch/debian-debootstrap:arm64-bullseye bash
```

**Q: 安装后无法打开摄像头/麦克风？**
→ 确保 Web 应用本身有正确的媒体权限请求逻辑。Electron 默认允许 `getUserMedia`。

**Q: HTTPS 证书报错？**
→ `main.js` 中已配置证书验证放宽（第 42 行）。生产环境应确保服务器使用有效证书。
