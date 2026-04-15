// Preload 脚本
// 当前应用为纯 Web 包装模式，无需暴露额外 API 到渲染进程
// 如需扩展功能可在此添加 contextBridge API

const { contextBridge } = require('electron');

contextBridge.exposeInMainWorld('trtcApp', {
  platform: process.platform,
  version: '1.0.0'
});
