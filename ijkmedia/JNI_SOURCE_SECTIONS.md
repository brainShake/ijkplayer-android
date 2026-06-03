# JNI 大文件分段注释索引

各文件内搜索 `/* ==========` 可跳转到对应章节。架构总览见 [ARCHITECTURE.md](ARCHITECTURE.md)。

| 文件 | 章节概要 |
|------|----------|
| `ijkplayer/android/ijkplayer_jni.c` | 一辅助 二数据源 三播放控制 四生命周期 五选项 六构造 七回调 八消息泵 九调试 十JNI注册 |
| `ijkplayer/ijkplayer.c` | 一全局/销毁 二状态/引用 三播放API 四循环/消息 |
| `ijkplayer/ff_ffplay.c` | 一队列 二解码 三显示时钟 四音视频线程 五读流 六ffp_* API |
| `ijkplayer/android/pipeline/ffpipenode_android_mediacodec_vdec.c` | 一Codec配置 二输入 三入队线程 四输出排空 五生命周期 |
| `ijkplayer/android/ffmpeg_api_jni.c` | 一base64 二RegisterNatives |
| `ijkplayer/ijkavformat/ijkiocache.c` | 一缓存树 二后台任务 三协议读写 |
| `ijksdl/android/ijksdl_android_jni.c` | 一JVM/线程 二异常与引用 三API Level |
| `ijksdl/android/ijksdl_codec_android_mediacodec_java.c` | 一生命周期 二输入输出缓冲 |
| `ijkj4a/.../IjkMediaPlayer.c` | 一字段 二静态回调 三类加载 |
| `ijkj4a/.../MediaCodec.c` | 一BufferInfo 二实例方法 三类加载 |

未列出的 j4a 生成文件结构类似（字段 getter/setter + `J4A_loadClass`）。
