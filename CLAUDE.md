# MapAndAgent - 项目专属指南

## 项目概述

这是一个基于 **Qt6** + **QML** 的跨平台应用程序，用于地图与智能代理功能。支持桌面和移动端部署。

## 技术栈

- **Qt6** 6.2+ (Quick 模块)
- **QML** (Qt Meta-Object Language)
- **CMake** 构建系统
- **MinGW** 编译器 (Windows)
- **Android** (ARMv8/aarch64)
- **iOS** (ARM64)

## 项目结构

```
MapAndAgent/
├── CMakeLists.txt    # CMake 构建配置
├── main.cpp          # 应用入口 (QQmlApplicationEngine)
├── main.qml          # QML 主界面
└── build/           # 构建输出目录
```

### CMakeLists.txt 更新规则 (重要!)

**每次添加新的 QML 文件时，必须更新 CMakeLists.txt：**

```cmake
qt_add_qml_module(appMapAndAgent
    URI MapAndAgent
    VERSION 1.0
    QML_FILES
        main.qml
        # 新增的 QML 文件必须在这里添加!
)
```

#### 添加新 QML 文件步骤

1. 创建 `MyComponent.qml` 文件
2. 在 `CMakeLists.txt` 的 `QML_FILES` 中添加：
   ```cmake
   QML_FILES
       main.qml
       MyComponent.qml   # 新增这一行
   ```
3. 重新构建项目

#### 常见编译错误

| 错误 | 原因 | 解决 |
|------|------|------|
| `Syntax error` | QML 语法错误或 component 位置错误 | 检查 component 定义位置 |
| 组件找不到 | 未在 CMakeLists.txt 中声明 | 添加到 QML_FILES |
| 找不到模块 | import 语句错误 | 检查 import 是否正确 |

## 常用命令

### 构建项目
```bash
cd MapAndAgent/build
cmake --build . --parallel
```

### 运行应用
```bash
# Windows
./build/MapAndAgent/appMapAndAgent.exe

# 或在 Qt Creator 中运行
```

### 清理构建
```bash
rm -rf build/*
```

## 移动端部署 (ARMv8)

### Android 部署
```bash
# 设置 Android NDK
export ANDROID_NDK_ROOT=/path/to/android-ndk

# Android ARM64 (ARMv8) 构建
cmake -B build-android -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=arm64-v8a \
    -DANDROID_PLATFORM=android-23

cmake --build build-android
```

### iOS 部署
```bash
# iOS ARM64 构建
cmake -B build-ios -GXcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_ARCHITECTURES=arm64

cmake --build build-ios
```

### 移动端注意事项

1. **Qt for Android**: 需要安装 Qt Android 模块
2. **屏幕适配**: 使用 `Screen.width`, `Screen.height` 适配不同屏幕
3. **触摸事件**: 使用 `TapHandler` 替代鼠标事件
4. **权限**: Android 需要配置文件权限 (网络、存储等)
5. **资源**: 移动端注意资源文件大小优化

## QML 开发规范

### 0. 检查 Import (重要!)
**每次添加控件或布局时，必须检查 import 语句：**

| 控件/组件 | 需要导入 |
|-----------|----------|
| `RowLayout`, `ColumnLayout`, `StackLayout` | `import QtQuick.Layouts` |
| `Button`, `TextField`, `Slider`, `Switch` | `import QtQuick.Controls` |
| `ListView`, `GridView`, `PathView` | `import QtQuick` (内置) |
| `Image`, `BorderImage` | `import QtQuick` (内置) |
| `Connections` | `import QtQuick` (内置) |
| `Timer` | `import QtQuick` (内置) |
| `Qt.platform.os` | `import QtQuick` (内置) |
| `Screen.width/height` | `import QtQuick` (内置) |

### 1. 组件导入
```qml
import QtQuick
import QtQuick.Controls  # 如需 UI 控件
import QtQuick.Layouts   # 如需布局
```

### 2. 窗口配置
```qml
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("App Title")
}
```

### 3. 信号与槽
使用 Qt 的信号槽机制进行组件通信：
```qml
signal mySignal(var data)
onMySignal: console.log(data)
```

## 代码风格

- **QML 文件**: 使用小写字母开头的驼峰命名 (e.g., `myComponent`)
- **属性**: 使用小写字母
- **ID**: 使用有意义的名称，避免使用 `rect1`, `rect2` 等
- **导入**: 按标准库优先排序

## 调试技巧

- 使用 `console.log()` 输出调试信息
- 使用 `console.assert()` 进行断言
- 查看构建输出目录的日志

### 移动端调试

- **Android**: 使用 `adb logcat` 查看日志
- **iOS**: 使用 Xcode 设备控制台
- **远程调试**: 启用 QML 远程调试功能

## 移动端 UI 适配

### 响应式布局
```qml
// 使用 Layout 布局系统
import QtQuick.Layouts

ColumnLayout {
    width: parent.width
    height: parent.height

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: parent.height * 0.3
    }
}
```

### 屏幕方向
```qml
// 锁定竖屏
Screen.orientationHandling: false

// 或在 main.cpp 中设置
app.setOrientation(Qt::PortraitOrientation);
```

### 高 DPI 适配
```qml
// 自动缩放
Text {
    font.pixelSize: 14 * Screen.devicePixelRatio
}
```

### 分辨率自适应

项目已实现跨平台分辨率适配：

```qml
Window {
    // 固定分辨率（桌面端）
    readonly property int desktopWidth: 1280
    readonly property int desktopHeight: 720

    // 根据平台设置分辨率
    width: isMobile ? Screen.desktopAvailableWidth : desktopWidth
    height: isMobile ? Screen.desktopAvailableHeight : desktopHeight

    // 检测是否为移动端平台
    readonly property bool isMobile: {
        var platform = Qt.platform.os;
        return platform === "android" || platform === "ios" ||
               platform === "winphone" || platform === "qnx";
    }
}
```

| 平台 | 分辨率策略 |
|------|-----------|
| Windows/macOS/Linux | 固定 1280x720 |
| Android/iOS | 全屏自适应 |

### 页面导航

项目实现了跨平台导航栏：

- **桌面端**: 左侧垂直导航栏 (宽度 120px)
- **移动端**: 下方水平导航栏 (高度 60px)

```qml
// 导航布局
RowLayout {
    // 导航栏根据平台自动调整方向
    layoutDirection: isMobile ? Qt.LeftToRight : Qt.TopToBottom

    // 页面切换使用 StackLayout
    StackLayout {
        currentIndex: currentIndex
    }
}
```

#### 页面组件

| 组件 | 说明 |
|------|------|
| `NavigationButton` | 导航按钮组件 |
| `PageMap` | 地图页面 |
| `PageAgent` | 代理页面 |
| `PageSettings` | 设置页面 |

#### 添加新页面

1. 在 `StackLayout` 中添加新组件
2. 在 `pageNames` 中添加页面名称
3. 更新 `Repeater` 的 `model` 值

## 扩展阅读

- [Qt 官方文档](https://doc.qt.io/)
- [QML 教程](https://doc.qt.io/qt-6/qml-tutorial.html)
- [Qt Android 部署](https://doc.qt.io/qt-6/android.html)
- [Qt iOS 部署](https://doc.qt.io/qt-6/ios.html)
