const { app, BrowserWindow, shell, session } = require('electron');
const path = require('path');

// 目标 URL
const APP_URL = 'https://kh.tyzfchina.com.cn:4433/';

let mainWindow = null;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 960,
    minHeight: 600,
    title: '智能终端',
    icon: path.join(__dirname, 'build', 'icons', '256x256.png'),
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true,
      sandbox: true,
      // 允许加载 HTTPS 站点的资源
      webSecurity: true
    },
    // 隐藏原生菜单栏（可选，如需调试可注释掉）
    autoHideMenuBar: true
  });

  // 加载目标 URL
  mainWindow.loadURL(APP_URL);

  // 处理外部链接 - 在系统默认浏览器中打开
  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  // 处理导航安全限制 - 仅允许在应用内跳转同源链接
  mainWindow.webContents.on('will-navigate', (event, url) => {
    const parsedUrl = new URL(url);
    const parsedAppUrl = new URL(APP_URL);
    
    if (parsedUrl.origin !== parsedAppUrl.origin) {
      event.preventDefault();
      shell.openExternal(url);
    }
  });

  // 窗口关闭时清理引用
  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

// 应用准备就绪后创建窗口
app.whenReady().then(() => {
  // 配置 session 以支持 HTTPS 站点（处理可能的证书问题）
  session.defaultSession.setCertificateVerifyProc((request, callback) => {
    // 对于生产环境，这里应该做更严格的证书验证
    // 当前允许自签名证书以便开发测试
    callback(0);
  });

  createWindow();

  // macOS 行为：点击 dock 图标时重新激活窗口
  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      createWindow();
    }
  });
});

// 所有窗口关闭时退出应用（非 macOS）
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
