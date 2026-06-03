# IJKPlayer Android（唯一源码树）

本目录 **即完整工程根目录**。在 Android Studio 中 **直接打开 `ijkplayer-android`**，不要打开上级 `ijkplayer` 或其它并列仓库。

## 目录一览

```
ijkplayer-android/
  ijkmedia/              JNI/C++ 源码（ijkplayer、ijksdl、ijkj4a…）
  ijkplayer-java/        Java API
  ijkplayer-armv5|armv7a|arm64|x86|x86_64/   各 ABI 打包模块
  ijkplayer-example/     示例 App
  prebuilt/
    ffmpeg/<arch>/       libijkffmpeg.so + FFmpeg 头文件
    ijkprof/jni/         NDK profiler stub
  tools/                 Gradle 脚本、同步工具
  docs/                  JNI 架构说明、方法索引
```

构建 **不依赖** 外部 `contrib/`、`ijkplayer-master/` 或仓库根 `ijkmedia/`。

## 环境

- JDK 17（或 AGP 7.4 支持的版本），设置 `JAVA_HOME`
- Android SDK：NDK `30.0.14904198`、CMake `3.22.1`（见根 `build.gradle`）

## 编译

```bat
gradlew.bat assembleDebug
```

64 位示例 APK：

```bat
gradlew.bat :ijkplayer-example:assembleAll64Debug
install-all64-debug.bat
```

## 预编译依赖

首次克隆若缺少 `prebuilt/ffmpeg/`，从任意机器上的 FFmpeg `output/` 目录导入：

```powershell
.\tools\sync-ffmpeg-prebuilt.ps1 -SourceRoot "D:\path\to\ffmpeg-build-root"
```

其中 `ffmpeg-build-root` 下应有 `ffmpeg-arm64/output`、`ffmpeg-armv7a/output` 等。详见 [`prebuilt/README.md`](prebuilt/README.md)。

## 开发文档

| 文档 | 说明 |
|------|------|
| [README-ANDROID-STUDIO.md](README-ANDROID-STUDIO.md) | Studio 打开方式、Run/调试、常见问题 |
| [ijkmedia/ARCHITECTURE.md](ijkmedia/ARCHITECTURE.md) | Native 模块架构 |
| [docs/JNI_ARCHITECTURE.md](docs/JNI_ARCHITECTURE.md) | Java ↔ JNI 协作 |

## 改 JNI

在 **`ijkmedia/`** 下直接编辑并提交；无需从外部同步。日常开发 ABI 见 `gradle.properties` 的 `ijk.devAbi`（默认 `arm64-v8a`）。
