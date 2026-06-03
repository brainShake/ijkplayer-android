set(_PLR "${IJKMEDIA_DIR}/ijkplayer")
set(IJKPLAYER_SOURCES
    ${_PLR}/ff_cmdutils.c
    ${_PLR}/ff_ffplay.c
    ${_PLR}/ff_ffpipeline.c
    ${_PLR}/ff_ffpipenode.c
    ${_PLR}/ijkmeta.c
    ${_PLR}/ijkplayer.c
    ${_PLR}/pipeline/ffpipeline_ffplay.c
    ${_PLR}/pipeline/ffpipenode_ffplay_vdec.c
    ${_PLR}/android/ffmpeg_api_jni.c
    ${_PLR}/android/ijkplayer_android.c
    ${_PLR}/android/ijkplayer_jni.c
    ${_PLR}/android/pipeline/ffpipeline_android.c
    ${_PLR}/android/pipeline/ffpipenode_android_mediacodec_vdec.c
    ${_PLR}/ijkavformat/allformats.c
    ${_PLR}/ijkavformat/cJSON.c
    ${_PLR}/ijkavformat/ijklas.c
    ${_PLR}/ijkavformat/ijklivehook.c
    ${_PLR}/ijkavformat/ijkmediadatasource.c
    ${_PLR}/ijkavformat/ijkio.c
    ${_PLR}/ijkavformat/ijkiomanager.c
    ${_PLR}/ijkavformat/ijkiocache.c
    ${_PLR}/ijkavformat/ijkioffio.c
    ${_PLR}/ijkavformat/ijkioandroidio.c
    ${_PLR}/ijkavformat/ijkioprotocol.c
    ${_PLR}/ijkavformat/ijkioapplication.c
    ${_PLR}/ijkavformat/ijkiourlhook.c
    ${_PLR}/ijkavformat/ijkasync.c
    ${_PLR}/ijkavformat/ijkurlhook.c
    ${_PLR}/ijkavformat/ijklongurl.c
    ${_PLR}/ijkavformat/ijksegment.c
    ${_PLR}/ijkavutil/ijkdict.c
    ${_PLR}/ijkavutil/ijkutils.c
    ${_PLR}/ijkavutil/ijkthreadpool.c
    ${_PLR}/ijkavutil/ijktree.c
    ${_PLR}/ijkavutil/ijkfifo.c
    ${_PLR}/ijkavutil/ijkstl.cpp
)

add_library(ijkplayer SHARED ${IJKPLAYER_SOURCES})
if(TARGET ijkffmpeg_pack)
    add_dependencies(ijkplayer ijkffmpeg_pack)
endif()
target_include_directories(ijkplayer PUBLIC
    ${_PLR}
    ${IJKMEDIA_DIR}
    ${IJK_FFMPEG_INCLUDE_DIR}
    ${IJKMEDIA_DIR}/ijkj4a
)
if(ANDROID_ABI STREQUAL "armeabi-v7a")
    target_compile_options(ijkplayer PRIVATE $<$<COMPILE_LANGUAGE:C>:-mfloat-abi=soft>)
endif()
target_compile_options(ijkplayer PRIVATE
    $<$<COMPILE_LANGUAGE:C>:-std=c99>
    $<$<COMPILE_LANGUAGE:C>:-Wno-psabi>
)
set_source_files_properties(${_PLR}/ijkavutil/ijkstl.cpp PROPERTIES
    COMPILE_OPTIONS "-Drestrict=;-Dav_restrict="
)
target_link_libraries(ijkplayer
    ijkffmpeg
    ijksdl
    ijksoundtouch
    android-ndk-profiler
    log android
)
