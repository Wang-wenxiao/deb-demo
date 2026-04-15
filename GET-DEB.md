# 🚀 获取 .deb 文件 — 3 步操作指南

## 前置条件
- 一个 [GitHub](https://github.com) 账号
- 已安装 Git（你已有）

---

## 第 1 步：创建 GitHub 仓库

打开 https://github.com/new ，填写：
- **Repository name**: `trtc-desktop-app`
- **Description**: `TRTC 智能终端桌面版 - Ubuntu ARM64 .deb`
- **Visibility**: Private（私有）或 Public（公开）
- ❌ 不要勾选 "Add a README file"
- 点击 **Create repository**

---

## 第 2 步：推送代码（复制粘贴到终端执行）

```bash
cd c:/deb/trtc-desktop-app

git branch -M main
git remote add origin https://github.com/<你的用户名>/trtc-desktop-app.git
git push -u origin main
```

> 把 `<你的用户名>` 换成你的 GitHub 用户名。

---

## 第 3 步：触发构建 & 下载 .deb

### 方式 A — 打 Tag 自动构建（推荐）

```bash
cd c:/deb/trtc-desktop-app
git tag v1.0.0
git push origin v1.0.0
```

### 方式 B — 手动触发（无需 tag）

1. 打开仓库页面 → **Actions** 标签页
2. 左侧选 **Build .deb (ARM64)**
3. 右侧点 **Run workflow** → **Run workflow**

### 等待构建完成（约 5~8 分钟）
构建完成后：

1. 进入 **Actions** → 点击最新的运行记录
2. 滚动到底部 → **Artifacts** 区域
3. 下载 `trtc-terminal-arm64-deb.zip`
4. 解压即得到 `.deb` 文件！

> 如果打了 v1.0.0 tag，还会自动在 **Releases** 页面生成下载链接。

---

## 安装到 Ubuntu ARM64 设备

```bash
# 传输 .deb 到设备后：
sudo dpkg -i trtc-terminal_1.0.0_arm64.deb
sudo apt-get install -f   # 自动安装依赖
# 启动应用
智能终端
```

---

## ⚡ 后续更新版本

```bash
cd c:/deb/trtc-desktop-app

# 改版本号（可选）
# 编辑 package.json 的 version 字段

git add -A
git commit -m "release: v1.0.1"
git push

# 打新 tag 触发构建
git tag v1.0.1
git push origin v1.0.1
```

---

## 📋 构建流程图

```
推送代码 + 打 Tag (v*)
       ↓
GitHub Actions 自动触发
       ↓
┌──────────────────────┐
│ Ubuntu runner 启动    │
│ ├─ install Node.js 20 │
│ ├─ npm install        │
│ └─ electron-builder   │
│    → linux deb arm64  │
│    → 输出 .deb 文件   │
└──────────────────────┘
       ↓
上传 Artifact (保留90天)
+ 创建 GitHub Release
       ↓
   你下载 .deb ✅
```
