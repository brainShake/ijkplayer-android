# ijkplayer JNI 代码框架说明

本文描述 `ijkmedia/` 与 Android Java 层如何协作，便于阅读与修改 native 代码。

## 一、总体分层

```
┌─────────────────────────────────────────────────────────────┐
│  App / ijkplayer-example                                     │
│    IjkVideoView → IjkMediaPlayer (Java)                      │
└───────────────────────────┬─────────────────────────────────┘
                            │ native 方法 + Handler 回调
┌───────────────────────────▼─────────────────────────────────┐
│  ijkplayer-java                                              │
│    IjkMediaPlayer.java, IjkNativeLoader.java                   │
└───────────────────────────┬─────────────────────────────────┘
                            │ RegisterNatives (jni4android)
┌───────────────────────────▼─────────────────────────────────┐
│  libijkplayer.so                                             │
│    ijkplayer/android/ijkplayer_jni.c   ← JNI 入口、方法表    │
│    ijkplayer/android/ijkplayer_android.c ← Android 管线创建   │
│    ijkj4a/                              ← Java↔C 辅助调用      │
│    ijkplayer/ijkplayer.c               ← 播放器状态机 API      │
│    ijkplayer/ff_ffplay.c               ← 基于 FFmpeg 的播放核心 │
│    ijkplayer/pipeline/                 ← 解码/输出管线抽象     │
└───────────────────────────┬─────────────────────────────────┘
                            │
┌───────────────────────────▼─────────────────────────────────┐
│  libijksdl.so        音视频输出 (Surface / AudioTrack / EGL)   │
│  libijkffmpeg.so     FFmpeg 预编译 (解封装/解码)               │
└─────────────────────────────────────────────────────────────┘
```

## 二、Native 库加载顺序

在 `IjkMediaPlayer.loadLibrariesOnce()` / `IjkExampleApplication` 中：

1. `libijkffmpeg.so` — FFmpeg
2. `libijksdl.so` — 依赖 ffmpeg
3. `libijkplayer.so` — 依赖上述两者

`JNI_OnLoad` 在加载 `libijkplayer.so` 时执行，完成 Java 方法注册与全局初始化。

## 三、Java 与 C 的绑定方式（jni4android）

**不是** 标准 `Java_tv_danmaku_ijk_media_player_IjkMediaPlayer_xxx` 导出函数。

流程：

1. `.j4a` 描述文件定义 Java 类字段/方法签名
2. 生成 `ijkj4a/j4a/class/.../IjkMediaPlayer.c` — 封装 `GetLongField`、`CallStaticVoidMethod` 等
3. `ijkplayer_jni.c` 中 `g_methods[]` 用 `RegisterNatives` 把 Java 的 `native` 名映射到 C 函数

对照表见 **`docs/JNI_INDEX.md`**（由 `tools/generate-jni-index.ps1` 生成）。

## 四、核心数据结构

### Java 侧

| 字段 / 概念 | 含义 |
|-------------|------|
| `mNativeMediaPlayer` (long) | 指向 native `IjkMediaPlayer*` 的指针值 |
| `mNativeMediaDataSource` | 自定义 `IMediaDataSource` 的全局引用 |
| `mNativeAndroidIO` | 自定义 `IAndroidIO` 的全局引用 |

### C 侧 `struct IjkMediaPlayer`（`ijkplayer_internal.h`）

| 成员 | 含义 |
|------|------|
| `FFPlayer *ffplayer` | FFmpeg 播放引擎 (`ff_ffplay`) |
| `msg_loop` / `msg_thread` | 消息泵线程入口 |
| `mp_state` | 状态机 (IDLE / PREPARED / STARTED …) |
| `weak_thiz` | Java `WeakReference` 全局引用，用于回调 |
| `data_source` | 当前 URL/路径字符串 |

## 五、关键调用链（按使用顺序）

### 1. 创建播放器

```
Java: new IjkMediaPlayer() → native_setup(weak_this)
  → ijkmp_android_create(message_loop)
      → ijkmp_create()           // 通用播放器对象
      → SDL_VoutAndroid_Create   // 视频输出到 Surface
      → ffpipeline_create_from_android  // MediaCodec 等 Android 管线
  → jni_set_media_player()       // 写入 Java mNativeMediaPlayer
  → ijkmp_set_weak_thiz()        // 保存 weak 引用供回调
```

### 2. 设置数据源与 Surface

```
_setDataSource(path) / _setDataSourceFd / IMediaDataSource
  → ijkmp_set_data_source() 等
_setVideoSurface(Surface)
  → ijkmp_android_set_surface() → SDL_Vout + pipeline
```

### 3. 异步准备与播放

```
_prepareAsync() → ijkmp_prepare_async() → ffp_prepare_async_l()
_start()        → ijkmp_start()
_pause() / _stop() / seekTo()
```

### 4. Native → Java 事件（消息泵）

FFplay 内部线程产生 `AVMessage` → 队列 → **`message_loop` 线程**：

```
message_loop (native 线程, 在 native_setup 时注册)
  → message_loop_n()
      → ijkmp_get_msg() 阻塞取消息
      → switch (FFP_MSG_xxx)
      → post_event() → J4AC_IjkMediaPlayer__postEventFromNative
          → Java Handler → onPrepared / onInfo / onError ...
```

### 5. 释放

```
_release() / native_finalize
  → ijkmp_shutdown / ijkmp_dec_ref
```

## 六、目录与文件职责

| 路径 | 职责 |
|------|------|
| `ijkmedia/ijkplayer/android/ijkplayer_jni.c` | **JNI 主文件**：RegisterNatives、所有 Java native 实现、消息泵 |
| `ijkmedia/ijkplayer/android/ijkplayer_android.c` | Android 专用：创建 player、绑 Surface、音量 |
| `ijkmedia/ijkplayer/android/ijkplayer_android.h` | 上述 API 声明 |
| `ijkmedia/ijkplayer/android/pipeline/` | Android MediaCodec 解码管线 |
| `ijkmedia/ijkplayer/ijkplayer.c` | 平台无关 API：`ijkmp_*` 状态机 |
| `ijkmedia/ijkplayer/ijkplayer.h` | 状态常量与对外 C API |
| `ijkmedia/ijkplayer/ijkplayer_internal.h` | `IjkMediaPlayer` 结构体定义 |
| `ijkmedia/ijkplayer/ff_ffplay.c` | FFmpeg 播放循环、解复用、解码调度 |
| `ijkmedia/ijkplayer/ijkavformat/` | 自定义协议 (cache、hook、android io) |
| `ijkmedia/ijkj4a/j4a/` | jni4android 生成的 Java 调用辅助 |
| `ijkmedia/ijksdl/` | 跨平台音视频输出抽象 |
| `ijkmedia/ijksdl/android/` | Android AudioTrack、EGL、MediaCodec 封装 |

## 七、线程模型（简图）

```
[Java 主线程]     调用 native 方法 (prepare/start/seek)
[FFplay 读线程]   读包、解码 (ff_ffplay 内部)
[FFplay 视频线程] 显示刷新
[message_loop]    专用线程：把 FFP_MSG_* 转成 Java 事件
[Java Handler]    postEventFromNative 投递到主线程处理 UI
```

注意：`inject_callback` 等可能在 **非 Java 主线程** 调用 JNI，通过 `SDL_JNI_SetupThreadEnv` 附加 JVM。

## 八、修改代码时的建议入口

| 需求 | 建议先看 |
|------|----------|
| 改 Java API 行为 | `IjkMediaPlayer.java` + `ijkplayer_jni.c` 对应 `g_methods` 项 |
| 改播放/缓冲/seek | `ff_ffplay.c`、`ijkplayer.c` |
| 改硬解 MediaCodec | `pipeline/ffpipenode_android_mediacodec_vdec.c` |
| 改渲染 Surface | `ijksdl/android/ijksdl_vout_android_*.c` |
| 改自定义 IO | `ijkavformat/ijkioandroidio.c`、`IjkMediaPlayer_setDataSourceCallback` |
| 改事件回调到 Java | `message_loop_n()` 里 `FFP_MSG_*` 分支 |
| 改网络/缓存协议 | `ijkavformat/ijkiocache.c` 等 |

## 九、与 Gradle / CMake 的关系

- **Java / JNI 源码**：Gradle 模块 **`:ijkmedia`**（工程根 `ijkplayer-android/ijkmedia/`，唯一源码树）
- **编译**：`IJKMEDIA_DIR` 指向 `:ijkmedia`；各 ABI 模块 CMake → `libijkplayer.so`、`libijksdl.so`
- **FFmpeg**：预编译 `prebuilt/ffmpeg/<arch>/libijkffmpeg.so`

IDE：打开 **`ijkplayer-android`** 根目录，Sync 后浏览 **`:ijkmedia`**。

**模块内架构（目录/线程/数据流）**：[`ijkmedia/ARCHITECTURE.md`](../ijkmedia/ARCHITECTURE.md)。
