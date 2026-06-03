set(_SDL "${IJKMEDIA_DIR}/ijksdl")
set(IJKSDL_SOURCES
    ${_SDL}/ijksdl_aout.c
    ${_SDL}/ijksdl_audio.c
    ${_SDL}/ijksdl_egl.c
    ${_SDL}/ijksdl_error.c
    ${_SDL}/ijksdl_mutex.c
    ${_SDL}/ijksdl_stdinc.c
    ${_SDL}/ijksdl_thread.c
    ${_SDL}/ijksdl_timer.c
    ${_SDL}/ijksdl_vout.c
    ${_SDL}/ijksdl_extra_log.c
    ${_SDL}/gles2/color.c
    ${_SDL}/gles2/common.c
    ${_SDL}/gles2/renderer.c
    ${_SDL}/gles2/renderer_rgb.c
    ${_SDL}/gles2/renderer_yuv420p.c
    ${_SDL}/gles2/renderer_yuv444p10le.c
    ${_SDL}/gles2/shader.c
    ${_SDL}/gles2/fsh/rgb.fsh.c
    ${_SDL}/gles2/fsh/yuv420p.fsh.c
    ${_SDL}/gles2/fsh/yuv444p10le.fsh.c
    ${_SDL}/gles2/vsh/mvp.vsh.c
    ${_SDL}/dummy/ijksdl_vout_dummy.c
    ${_SDL}/ffmpeg/ijksdl_vout_overlay_ffmpeg.c
    ${_SDL}/ffmpeg/abi_all/image_convert.c
    ${_SDL}/android/android_audiotrack.c
    ${_SDL}/android/android_nativewindow.c
    ${_SDL}/android/ijksdl_android_jni.c
    ${_SDL}/android/ijksdl_aout_android_audiotrack.c
    ${_SDL}/android/ijksdl_aout_android_opensles.c
    ${_SDL}/android/ijksdl_codec_android_mediacodec_dummy.c
    ${_SDL}/android/ijksdl_codec_android_mediacodec_internal.c
    ${_SDL}/android/ijksdl_codec_android_mediacodec_java.c
    ${_SDL}/android/ijksdl_codec_android_mediacodec.c
    ${_SDL}/android/ijksdl_codec_android_mediadef.c
    ${_SDL}/android/ijksdl_codec_android_mediaformat_java.c
    ${_SDL}/android/ijksdl_codec_android_mediaformat.c
    ${_SDL}/android/ijksdl_vout_android_nativewindow.c
    ${_SDL}/android/ijksdl_vout_android_surface.c
    ${_SDL}/android/ijksdl_vout_overlay_android_mediacodec.c
)

add_library(ijksdl SHARED ${IJKSDL_SOURCES})
target_include_directories(ijksdl PUBLIC
    ${_SDL}
    ${IJKMEDIA_DIR}
    ${IJK_FFMPEG_INCLUDE_DIR}
    ${_SDL}/../ijkyuv/include
    ${IJKMEDIA_DIR}/ijkj4a
)
target_compile_options(ijksdl PRIVATE $<$<COMPILE_LANGUAGE:C>:-std=c99>)
target_include_directories(ijksdl PRIVATE ${CMAKE_SYSROOT}/usr/include)
target_link_libraries(ijksdl
    ijkffmpeg
    yuv_static
    ijkj4a
    cpufeatures
    log android OpenSLES EGL GLESv2
)
