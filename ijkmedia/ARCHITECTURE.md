# `:ijkmedia` 模块代码架构说明

本文描述 Gradle 模块 **`:ijkmedia`**（`ijkplayer-android/ijkmedia/`）的目录职责、线程模型与调用关系。  
与 Java 层协作的 JNI 总览另见 [`../docs/JNI_ARCHITECTURE.md`](../docs/JNI_ARCHITECTURE.md)，方法对照表见 [`../docs/JNI_INDEX.md`](../docs/JNI_INDEX.md)。

---

## 1. 模块在工程中的位置

```
ijkplayer-android/                    ← Android Studio 打开的 Gradle 根（唯一源码树）
├── ijkmedia/                         ← 本模块（:ijkmedia），JNI 源码 + 开发态 native 编译
│   ├── build.gradle                  ← 按 ijk.devAbi 编一份 libijkplayer/ijksdl
│   ├── cmake/                        ← 原生构建脚本（替代 Android.mk）
│   ├── src/main/cpp/CMakeLists.txt   ← Gradle CMake 入口
│   ├── ijkplayer/                    ← 播放核心 + Android JNI
│   ├── ijksdl/                       ← 音视频输出抽象（Surface / AudioTrack / GLES）
│   ├── ijkj4a/                       ← jni4android 生成的 Java↔C 桥
│   ├── ijkyuv/                       ← YUV 缩放/旋转（libyuv）
│   └── ijksoundtouch/                ← 变速不变调（可选）
├── ijkplayer-arm64 等                ← 各 ABI 正式打包模块，同样编译本目录源码
├── ijkplayer-java                    ← Java API
└── (无 ndk-build)                    ← 已移除 Android.mk，见 cmake/README.md
```

| 产物 | 由谁链接 | 说明 |
|------|----------|------|
| `libijkplayer.so` | CMake 编译 `ijkplayer/` + `ijkj4a/` | JNI、状态机、FFplay |
| `libijksdl.so` | CMake 编译 `ijksdl/` | 渲染与音频输出 |
| `libijkffmpeg.so` | **预编译** IMPORTED | 来自 `prebuilt/ffmpeg/<arch>/` 或模块 `libs/` |

---

## 2. 源码子树职责

### 2.1 `ijkplayer/` — 播放逻辑

| 路径 | 职责 |
|------|------|
| `android/ijkplayer_jni.c` | **JNI 入口**：`JNI_OnLoad`、`g_methods[]`、`message_loop` 事件泵 |
| `android/ijkplayer_android.c` | 创建 Android 管线：`SDL_VoutAndroid`、`ffpipeline_create_from_android` |
| `android/pipeline/` | MediaCodec 硬解节点、`ffpipeline_android` |
| `android/ffmpeg_api_jni.c` | FFmpeg 与 Java 的辅助 JNI |
| `ijkplayer.c` | **ijkmp_*** 状态机 API（与 `MediaPlayer` 语义对齐） |
| `ijkplayer.h` / `ijkplayer_internal.h` | 对外 API、`struct IjkMediaPlayer` 布局 |
| `ff_ffplay.c` / `ff_ffplay.h` | **FFplay 引擎**：解复用、解码调度、缓冲、时钟 |
| `ff_ffpipeline.c` | 管线抽象：挂接 vout、创建解码节点 |
| `ijkavformat/` | 自定义 IO：cache、hook、android io、segment |
| `ijkavutil/` | 字典、线程池、FIFO 等工具 |

### 2.2 `ijksdl/` — 输出层

| 路径 | 职责 |
|------|------|
| `android/` | `AudioTrack`、ANativeWindow Surface、MediaCodec overlay |
| `gles2/` | OpenGL ES2 渲染 YUV/RGB |
| `ffmpeg/` | 软解帧转 overlay |
| `ijksdl_vout.c` | 视频输出接口 |
| `ijksdl_aout.c` | 音频输出接口 |

### 2.3 `ijkj4a/` — jni4android

- `j4a/class/.../*.c`：由 `.j4a` 描述文件生成，封装 `GetLongField`、`CallVoidMethod` 等。
- `j4a/j4a_base.h`：异常检查、类加载宏（`J4A_LOAD_CLASS` 等）。
- **ijkplayer_jni.c 不直接写字段 ID**，而通过 `J4AC_IjkMediaPlayer__*` 访问 Java。

### 2.4 `ijkyuv/`、`ijksoundtouch/`

- **ijkyuv**：平面 YUV 缩放/旋转，CMake 目标 `yuv_static`。
- **ijksoundtouch**：`ijksoundtouch_wrap.c` 包装，供倍速播放选项使用。

---

## 3. 分层与数据流

```
App (Java)
    │  IjkMediaPlayer.prepareAsync / start / setSurface
    ▼
ijkplayer_jni.c          RegisterNatives(g_methods)
    │  mNativeMediaPlayer → IjkMediaPlayer*
    ▼
ijkplayer.c (ijkmp_*)    状态机 + 互斥锁
    │  mp->ffplayer
    ▼
ff_ffplay.c (ffp_*)      读包、解码、音视频同步
    │                    ├─ ijkavformat (自定义协议)
    │                    └─ libijkffmpeg.so
    ▼
ffpipeline / ffpipenode   软解或 MediaCodec 硬解
    ▼
ijksdl                   AudioTrack / Surface+GLES 显示
```

**消息反向路径**（native → Java）：

1. `ff_ffplay` 内部产生 `FFP_MSG_*`（准备完成、缓冲、错误等）。
2. `message_loop` 线程调用 `message_loop_n`，读取消息后 `postEventFromNative`。
3. Java `Handler` 在 UI 线程处理 `MEDIA_PREPARED` 等事件。

---

## 4. 核心对象

### 4.1 `IjkMediaPlayer`（`ijkplayer_internal.h`）

| 成员 | 含义 |
|------|------|
| `ref_count` | 引用计数；JNI `jni_get_media_player` 会 `ijkmp_inc_ref` |
| `ffplayer` | `FFPlayer*`，真正干活的 FFplay 实例 |
| `msg_thread` | 跑 `message_loop`，专用于 JNI 回调 |
| `mp_state` | `MP_STATE_IDLE` … `MP_STATE_END` |
| `weak_thiz` | Java 弱引用全局引用，避免循环 GC |
| `data_source` | URL / 文件路径 |

### 4.2 `FFPlayer`（`ff_ffplay_def.h`）

解复用器、解码器、packet 队列、音视频时钟、`SDL_Vout`、`IJKFF_Pipeline` 等均挂在此结构。

---

## 5. 典型生命周期（Android）

| 阶段 | Java | Native |
|------|------|--------|
| 加载 so | `IjkMediaPlayer.loadLibrariesOnce()` | 加载顺序：ffmpeg → sd l → player；`JNI_OnLoad` 注册 natives |
| 创建 | `new IjkMediaPlayer()` → `native_setup` | `ijkmp_android_create(message_loop)` |
| 设 Surface | `setSurface(Surface)` | `ijkmp_android_set_surface` → pipeline + vout |
| 数据源 | `setDataSource(url)` | `ijkmp_set_data_source` → `MP_STATE_INITIALIZED` |
| 准备 | `prepareAsync()` | `ijkmp_prepare_async` → 异步 `ffp_prepare_async_l` |
| 播放 | `start()` | `ijkmp_start` → `ffp_start_l` |
| 释放 | `release()` | `ijkmp_shutdown` / `ijkmp_dec_ref` |

---

## 6. 线程模型（阅读 native 时必看）

| 线程 | 典型工作 | 能否直接调 JNI |
|------|----------|----------------|
| Java 主线程 | UI、调用 `prepareAsync` 等 | 是 |
| `message_loop` | 把 `FFP_MSG_*` 投递到 Java | 是（已 `AttachCurrentThread`） |
| FFplay 解码/读包 | `ff_read`、`ffplay` 循环 | **否**，应通过消息队列 |
| SDL 音频回调 | 填充 PCM | 否 |

因此 **`message_loop` 存在的原因**：避免在解码线程直接 `CallVoidMethod`。

---

## 7. 构建说明

- **开发单 ABI**：`gradle.properties` 中 `ijk.devAbi=arm64-v8a`，执行  
  `gradlew :ijkmedia:assembleDebug`
- **正式 APK**：`gradlew :ijkplayer-example:installAll64Debug`（含各 ABI 的 .so）
CMake 变量 **`IJKMEDIA_DIR`** 指向本模块根目录（含 `ijkplayer/`、`ijksdl/` 等子文件夹）。

---

## 8. 大文件分段注释

源码中搜索 `/* =============================================================================` 可定位章节；文件与章节对照见 **[JNI_SOURCE_SECTIONS.md](JNI_SOURCE_SECTIONS.md)**。

## 9. 修改代码时的入口建议

| 需求 | 优先打开 |
|------|----------|
| Java native 行为 | `ijkplayer/android/ijkplayer_jni.c` + `JNI_INDEX.md` |
| Surface / 硬解 | `ijkplayer/android/ijkplayer_android.c`、`pipeline/ffpipenode_android_mediacodec_vdec.c` |
| 缓冲、seek、协议 | `ijkplayer/ff_ffplay.c`、`ijkavformat/` |
| 画面渲染 | `ijksdl/android/`、`ijksdl/gles2/` |
| 状态机错误码 | `ijkplayer/ijkplayer.c`、`ijkplayer.h` |

---

## 10. 源码树约定

`ijkmedia/` 即 **唯一 JNI 源码树**（工程根为 `ijkplayer-android/`）。所有 native 修改在本目录完成并纳入版本管理，不依赖外部 `ijkmedia/` 或 `contrib/` 目录。
