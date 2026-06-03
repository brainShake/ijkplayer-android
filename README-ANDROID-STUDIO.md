# Android Studio 开发指南

工程根目录即 **[`ijkplayer-android`](README.md)**（唯一源码树）。**File → Open** 选择本文件夹，然后 **Sync Project with Gradle Files**。

**`:ijkmedia` 模块架构**：[`ijkmedia/ARCHITECTURE.md`](ijkmedia/ARCHITECTURE.md)  
**JNI 与 Java**：[`docs/JNI_ARCHITECTURE.md`](docs/JNI_ARCHITECTURE.md)  
**方法对照表**：[`docs/JNI_INDEX.md`](docs/JNI_INDEX.md)

## JNI 源码位置

| 路径 | 内容 |
|------|------|
| **`:ijkmedia`** | JNI/C 唯一源码树（`ijkmedia/ijkplayer` 等） |
| `ijkmedia/cmake/` | CMake 构建脚本 |
| `prebuilt/ffmpeg/<arch>/` | 预编译 `libijkffmpeg.so` + 头文件 |

## IDE 配置

1. 安装 **NDK + CMake**（SDK Manager，版本与根 `build.gradle` 一致）。
2. **Project** 视图：展开 **`ijkmedia`** 或各 ABI 模块的 JNI 源集。

## `gradle.properties`（可选）

```properties
ijk.devNativeFromSource=true
ijk.devAbi=arm64-v8a
```

- **`:ijkmedia`**：与 `ijk.devAbi` 一致，快速编 native（`gradlew :ijkmedia:assembleDebug`）。
- **`ijkplayer-arm64`** 等：各 ABI 正式打包，共用 `:ijkmedia` 源码。

## 编译与安装

```bat
gradlew :ijkmedia:assembleDebug
gradlew :ijkplayer-arm64:assembleDebug
gradlew :ijkplayer-example:installAll64Debug
```

或 **`install-all64-debug.bat`**。

**不要**用仅 Java 的 Run（约 2MB、无 `.so`）。Variant 选 **`all64Debug`**，改 native 时关闭 **Apply Changes**。

## 模块分工

| 模块 | 作用 |
|------|------|
| **ijkmedia** | JNI 源码 + 开发态单 ABI native |
| **ijkplayer-arm64** 等 | 各 ABI 的 `libijkplayer.so` / `libijksdl.so` |
| **ijkplayer-java** | Java API |
| **ijkplayer-example** | 示例 App |

`libijkffmpeg.so` 来自 `prebuilt/ffmpeg/<arch>/`；更新见 [`prebuilt/README.md`](prebuilt/README.md)。

## Java → JNI 跳转

ijk 使用 **jni4android**（`RegisterNatives`），不能从 Java 直接跳到 `Java_tv_danmaku_...`。

1. Sync Gradle（`ijkplayer-java` 关联 CMake 便于索引）。
2. 查 **[`docs/JNI_INDEX.md`](docs/JNI_INDEX.md)**。
3. 在 Java `native` 方法上 **Ctrl+Shift+F** 搜表中 **C 函数名**。
4. 或打开 **`ijkmedia/ijkplayer/android/ijkplayer_jni.c`** 搜 Java 方法名字符串。

## 常见问题

- **看不到 `ijkmedia`**：Sync Gradle；确认打开的是 **本目录** 而非上级文件夹。
- **改了 C 仍是旧逻辑**：用 `installAll64Debug` 全量安装，勿仅 Apply Changes。
- **崩溃 / 缺 libijkffmpeg**：APK 应 **> 25MB**，且含 `lib/arm64-v8a/*.so`。
- **`ff_read` 崩溃（退出播放）**：多为 APK 里 **2018 旧 `libijkplayer.so` + 新版 `libijkffmpeg.so` 混用**。勿在 CMake 模块的 `src/main/libs` 留旧 player/sdl；用 `gradlew :ijkplayer-example:installAll64Debug` 重装（会从 CMake 产物同步 .so）。
- **缺 prebuilt**：运行 `.\tools\sync-ffmpeg-prebuilt.ps1 -SourceRoot <含 ffmpeg-*/output 的目录>`。
