# IJKPlayer Android

基于 [Bilibili ijkplayer](https://github.com/bilibili/ijkplayer) 整理的 **自包含 Android 工程**：JNI 源码、CMake 构建、FFmpeg 预编译库与示例 App 均在仓库内，无需外部 `contrib` 或并列源码树。

**仓库地址**：https://github.com/brainShake/ijkplayer-android

---

## 特性

- **唯一源码树**：用 Android Studio 直接打开本目录即可开发、编译。
- **工程内预编译**：`prebuilt/ffmpeg/<arch>/` 提供 `libijkffmpeg.so` 与头文件；`prebuilt/ijkprof/` 提供 profiler stub。
- **CMake 构建**：`libijkplayer.so`、`libijksdl.so` 由 CMake 与各 ABI 模块编译，与当前 FFmpeg 版本一致。
- **多 ABI 示例包**：`ijkplayer-example` 支持 `all64Debug` / `all32Debug` 等风味。

---

## 环境要求

| 项 | 版本 / 说明 |
|----|-------------|
| JDK | 17（推荐），配置 `JAVA_HOME` |
| Android Gradle Plugin | 7.4.2 |
| compileSdk | 33 |
| NDK | 30.0.14904198 |
| CMake | 3.22.1（SDK Manager 安装） |

在 `local.properties` 中配置本机 SDK 路径（该文件已加入 `.gitignore`，不会提交）。

---

## 快速开始

### 克隆

```bash
git clone https://github.com/brainShake/ijkplayer-android.git
cd ijkplayer-android
```

克隆后已包含 `prebuilt/`，一般可直接编译。若你裁剪了 `prebuilt/ffmpeg/`，见下方「导入 FFmpeg 预编译库」。

### 编译

```bat
gradlew.bat assembleDebug
```

### 安装示例 App（推荐，含完整 native 库）

```bat
gradlew.bat :ijkplayer-example:installAll64Debug
```

或双击 **`install-all64-debug.bat`**。安装成功的 APK 约 **30MB**（含 `lib/arm64-v8a/*.so` 等）。

---

## 工程结构

```
ijkplayer-android/
├── ijkmedia/                 # JNI/C++ 唯一源码（ijkplayer、ijksdl、ijkj4a…）
├── ijkplayer-java/           # Java API
├── ijkplayer-armv5/          # 各 ABI 库模块
├── ijkplayer-armv7a/
├── ijkplayer-arm64/
├── ijkplayer-x86/
├── ijkplayer-x86_64/
├── ijkplayer-exo/            # Exo 相关扩展
├── ijkplayer-example/        # 示例应用
├── prebuilt/
│   ├── ffmpeg/<arch>/        # libijkffmpeg.so + include/
│   └── ijkprof/jni/          # NDK profiler stub
├── tools/                    # Gradle 脚本、同步与推送工具
└── docs/                     # JNI 架构、方法索引
```

---

## 模块说明

| 模块 | 作用 |
|------|------|
| **ijkmedia** | JNI 源码；按 `ijk.devAbi` 编译单 ABI，便于 IDE 索引与调试 |
| **ijkplayer-arm64** 等 | 各 ABI 正式打包 `libijkplayer.so` / `libijksdl.so` |
| **ijkplayer-java** | 对外的 `IjkMediaPlayer` 等 Java API |
| **ijkplayer-example** | 演示播放、文件浏览的示例 App |

`libijkffmpeg.so` 来自 `prebuilt/ffmpeg/`，由 Gradle 任务 `packageLibijkffmpeg` 打入 AAR/APK。

---

## 开发说明

### 打开工程

**File → Open** 选择 **`ijkplayer-android`** 根目录（不要打开上级文件夹），然后 **Sync Project with Gradle Files**。

更详细的 Studio 用法、JNI 跳转与常见问题见 **[README-ANDROID-STUDIO.md](README-ANDROID-STUDIO.md)**。

### 修改 JNI

在 **`ijkmedia/`** 下直接改 C/C++ 并提交，无需从其它目录同步。

`gradle.properties` 中常用项：

```properties
# 日常只编一个 ABI（默认 arm64-v8a）
ijk.devAbi=arm64-v8a
```

改 native 后建议：

```bat
gradlew :ijkmedia:assembleDebug
gradlew :ijkplayer-example:installAll64Debug
```

不要用仅 Java 的 Studio Run（约 2MB、无 `.so`）；Variant 选 **`all64Debug`**，改 C 代码时关闭 **Apply Changes**。

### 导入 FFmpeg 预编译库

若缺少 `prebuilt/ffmpeg/<arch>/`，从已有 FFmpeg 构建目录导入（目录下需有 `ffmpeg-arm64/output` 等）：

```powershell
.\tools\sync-ffmpeg-prebuilt.ps1 -SourceRoot "D:\path\to\contrib\build"
```

详见 **[prebuilt/README.md](prebuilt/README.md)**。

### 推送到 GitHub（HTTP 代理示例）

```powershell
.\tools\push-github.ps1
# 默认代理 http://127.0.0.1:1080，可在脚本参数中修改 -Proxy
```

---

## 常见问题

| 现象 | 处理 |
|------|------|
| APK 约 2MB、播放崩溃 | 未打入 native 库；使用 `installAll64Debug` 或 `embed-example-jni` 同步的 CMake 产物 |
| 退出播放时 `ff_read` 崩溃 | 多为 **旧版 `libijkplayer.so` + 新版 `libijkffmpeg.so` 混用**；勿在 CMake 模块的 `src/main/libs` 保留 2018 旧 player/sdl，重新 `installAll64Debug` |
| 找不到 `ijkmedia` | 确认打开的是本仓库根目录并 Sync Gradle |
| 克隆后缺 FFmpeg | 运行 `sync-ffmpeg-prebuilt.ps1` 或从完整仓库拉取 `prebuilt/` |

---

## 文档索引

| 文档 | 内容 |
|------|------|
| [README-ANDROID-STUDIO.md](README-ANDROID-STUDIO.md) | Android Studio 开发、运行、调试 |
| [ijkmedia/ARCHITECTURE.md](ijkmedia/ARCHITECTURE.md) | Native 模块目录与线程模型 |
| [docs/JNI_ARCHITECTURE.md](docs/JNI_ARCHITECTURE.md) | Java ↔ JNI 协作 |
| [docs/JNI_INDEX.md](docs/JNI_INDEX.md) | Java native 方法与 C 函数对照 |

---

## 致谢

本项目核心播放逻辑来源于 **ijkplayer** 开源项目及其 FFmpeg 集成方案，在此向原作者与社区致谢。

---

## 联系

维护者：**brainShake**（GitHub）

如有问题、合作或反馈，请联系：

**349977016@qq.com**
