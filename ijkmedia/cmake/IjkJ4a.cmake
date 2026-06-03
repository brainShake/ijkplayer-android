set(_J4A "${IJKMEDIA_DIR}/ijkj4a")
set(IJKJ4A_SOURCES
    ${_J4A}/j4a/j4a_allclasses.c
    ${_J4A}/j4a/j4a_base.c
    ${_J4A}/j4a/class/android/media/AudioTrack.c
    ${_J4A}/j4a/class/android/media/MediaCodec.c
    ${_J4A}/j4a/class/android/media/MediaFormat.c
    ${_J4A}/j4a/class/android/media/PlaybackParams.c
    ${_J4A}/j4a/class/android/os/Build.c
    ${_J4A}/j4a/class/android/os/Bundle.c
    ${_J4A}/j4a/class/java/nio/Buffer.c
    ${_J4A}/j4a/class/java/nio/ByteBuffer.c
    ${_J4A}/j4a/class/java/util/ArrayList.c
    ${_J4A}/j4a/class/tv/danmaku/ijk/media/player/misc/IMediaDataSource.c
    ${_J4A}/j4a/class/tv/danmaku/ijk/media/player/misc/IAndroidIO.c
    ${_J4A}/j4a/class/tv/danmaku/ijk/media/player/IjkMediaPlayer.c
    ${_J4A}/j4au/class/android/media/AudioTrack.util.c
    ${_J4A}/j4au/class/java/nio/ByteBuffer.util.c
)
add_library(ijkj4a STATIC ${IJKJ4A_SOURCES})
target_include_directories(ijkj4a PUBLIC ${_J4A})
target_compile_options(ijkj4a PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c99>)
target_link_libraries(ijkj4a cpufeatures)
