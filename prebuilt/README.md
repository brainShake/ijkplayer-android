# 工程内预编译依赖

Gradle/CMake **只读取本目录**，不访问上级或其它仓库中的 `contrib/`。

## 目录结构

```
prebuilt/
  ffmpeg/
    arm64/          libijkffmpeg.so + include/ + config.h
    armv7a/
    armv5/
    x86/
    x86_64/         若仅有头文件，需自备 libijkffmpeg.so
  ijkprof/jni/      NDK profiler stub（prof.c / prof.h）
```

## 从外部 FFmpeg 构建目录导入（一次性）

源目录布局示例：`D:\build\contrib\build\ffmpeg-arm64\output\` …

```powershell
cd ijkplayer-android
.\tools\sync-ffmpeg-prebuilt.ps1 -SourceRoot "D:\build\contrib\build"
```

## 与 ABI 模块 `src/main/libs` 的关系

- **CMake 模块**（arm64、armv7a、x86 等）：三个 `.so` 均由 CMake + `prebuilt/ffmpeg` 产出；**不要**在 `src/main/libs` 留旧版 `libijkplayer.so`/`libijksdl.so`（会与新版 `libijkffmpeg.so` 混用导致 `ff_read` 崩溃）。示例 App 通过 `sync-example-jni` 从各模块 `build/intermediates/library_jni` 打包。
- **纯预编译模块**（armv5、默认 x86_64）：三个 `.so` 均在 `ijkplayer-*/src/main/libs/<abi>/`。
