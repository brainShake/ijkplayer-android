# IjkMediaPlayer JNI index (RegisterNatives)

ijk uses jni4android: Java native methods are registered at runtime in g_methods[], not Java_* exports.
Use this table to jump from Java to C in ijkplayer_jni.c (Ctrl+Shift+F the C symbol).

| Java native name | JNI signature | C function |
|------------------|---------------|------------|
| `_setDataSourceFd` | `(I)V` | `IjkMediaPlayer_setDataSourceFd` |
| `_setDataSource` | `(Ltv/danmaku/ijk/media/player/misc/IMediaDataSource;)V` | `IjkMediaPlayer_setDataSourceCallback` |
| `_setAndroidIOCallback` | `(Ltv/danmaku/ijk/media/player/misc/IAndroidIO;)V` | `IjkMediaPlayer_setAndroidIOCallback` |
| `_setVideoSurface` | `(Landroid/view/Surface;)V` | `IjkMediaPlayer_setVideoSurface` |
| `_prepareAsync` | `()V` | `IjkMediaPlayer_prepareAsync` |
| `_start` | `()V` | `IjkMediaPlayer_start` |
| `_stop` | `()V` | `IjkMediaPlayer_stop` |
| `seekTo` | `(J)V` | `IjkMediaPlayer_seekTo` |
| `_pause` | `()V` | `IjkMediaPlayer_pause` |
| `isPlaying` | `()Z` | `IjkMediaPlayer_isPlaying` |
| `getCurrentPosition` | `()J` | `IjkMediaPlayer_getCurrentPosition` |
| `getDuration` | `()J` | `IjkMediaPlayer_getDuration` |
| `_release` | `()V` | `IjkMediaPlayer_release` |
| `_reset` | `()V` | `IjkMediaPlayer_reset` |
| `setVolume` | `(FF)V` | `IjkMediaPlayer_setVolume` |
| `getAudioSessionId` | `()I` | `IjkMediaPlayer_getAudioSessionId` |
| `native_init` | `()V` | `IjkMediaPlayer_native_init` |
| `native_setup` | `(Ljava/lang/Object;)V` | `IjkMediaPlayer_native_setup` |
| `native_finalize` | `()V` | `IjkMediaPlayer_native_finalize` |
| `_setOption` | `(ILjava/lang/String;Ljava/lang/String;)V` | `IjkMediaPlayer_setOption` |
| `_setOption` | `(ILjava/lang/String;J)V` | `IjkMediaPlayer_setOptionLong` |
| `_getColorFormatName` | `(I)Ljava/lang/String;` | `IjkMediaPlayer_getColorFormatName` |
| `_getVideoCodecInfo` | `()Ljava/lang/String;` | `IjkMediaPlayer_getVideoCodecInfo` |
| `_getAudioCodecInfo` | `()Ljava/lang/String;` | `IjkMediaPlayer_getAudioCodecInfo` |
| `_getMediaMeta` | `()Landroid/os/Bundle;` | `IjkMediaPlayer_getMediaMeta` |
| `_setLoopCount` | `(I)V` | `IjkMediaPlayer_setLoopCount` |
| `_getLoopCount` | `()I` | `IjkMediaPlayer_getLoopCount` |
| `_getPropertyFloat` | `(IF)F` | `ijkMediaPlayer_getPropertyFloat` |
| `_setPropertyFloat` | `(IF)V` | `ijkMediaPlayer_setPropertyFloat` |
| `_getPropertyLong` | `(IJ)J` | `ijkMediaPlayer_getPropertyLong` |
| `_setPropertyLong` | `(IJ)V` | `ijkMediaPlayer_setPropertyLong` |
| `_setStreamSelected` | `(IZ)V` | `ijkMediaPlayer_setStreamSelected` |
| `native_profileBegin` | `(Ljava/lang/String;)V` | `IjkMediaPlayer_native_profileBegin` |
| `native_profileEnd` | `()V` | `IjkMediaPlayer_native_profileEnd` |
| `native_setLogLevel` | `(I)V` | `IjkMediaPlayer_native_setLogLevel` |
| `_setFrameAtTime` | `(Ljava/lang/String;JJII)V` | `IjkMediaPlayer_setFrameAtTime` |

Source: ijkmedia/ijkplayer/android/ijkplayer_jni.c

IDE: Sync Gradle (ijkplayer-java links CMake). Search C function name from this table.
