# ijkmedia CMake 构建（替代 Android.mk）

由 Gradle `externalNativeBuild.cmake` 引用，生成：

- `libijkplayer.so`
- `libijksdl.so`
- 静态库 `ijkj4a`、`yuv_static`、`ijksoundtouch`、`android-ndk-profiler`
- 链接预编译 `libijkffmpeg.so`（`IjkFfmpeg.cmake`）

## 入口

| 调用方 | CMakeLists |
|--------|------------|
| `:ijkmedia` | `ijkmedia/src/main/cpp/CMakeLists.txt` → `../../../cmake` |
| `:ijkplayer-arm64` 等 ABI 模块 | `ijkplayer-*/src/main/cpp/CMakeLists.txt` |

Gradle 传入 `-DIJKMEDIA_DIR=<ijkmedia 模块根>`、`-DFFMPEG_DIR=<工程>/prebuilt/ffmpeg/<arch>`。

## 模块划分（对应原 Android.mk）

| 文件 | 原 LOCAL_MODULE |
|------|-----------------|
| `IjkPlayer.cmake` | `ijkplayer` |
| `IjkSdl.cmake` | `ijksdl` |
| `IjkJ4a.cmake` | `ijkj4a`（静态） |
| `IjkYuv.cmake` | `yuv_static` |
| `IjkSoundTouch.cmake` | `ijksoundtouch` |
| `IjkFfmpeg.cmake` | `ijkffmpeg`（IMPORTED） |
| `IjkCpuFeatures.cmake` | `cpufeatures` |
| `IjkProfiler.cmake` | `android-ndk-profiler` |

所有原生构建脚本仅维护在本目录（`ijkmedia/cmake/`），工程内已无 `ndk-common`。
