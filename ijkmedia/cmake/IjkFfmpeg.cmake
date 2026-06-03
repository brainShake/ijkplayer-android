# Prebuilt libijkffmpeg.so (from prebuilt/ffmpeg/<arch> or module libs fallback)
if(NOT FFMPEG_DIR)
    message(FATAL_ERROR "FFMPEG_DIR not set")
endif()

if(IJK_FFMPEG_PREBUILT_SO AND EXISTS "${IJK_FFMPEG_PREBUILT_SO}")
    set(_FFMPEG_SO "${IJK_FFMPEG_PREBUILT_SO}")
else()
    set(_FFMPEG_SO "${FFMPEG_DIR}/libijkffmpeg.so")
    if(NOT EXISTS "${_FFMPEG_SO}" AND IJK_MODULE_JNI_DIR)
        set(_FFMPEG_SO "${IJK_MODULE_JNI_DIR}/ffmpeg/prebuilt/${ANDROID_ABI}/libijkffmpeg.so")
    endif()
endif()
if(NOT EXISTS "${_FFMPEG_SO}")
    message(FATAL_ERROR "libijkffmpeg.so not found under ${FFMPEG_DIR} or prebuilt/${ANDROID_ABI}")
endif()

add_library(ijkffmpeg SHARED IMPORTED GLOBAL)
set_target_properties(ijkffmpeg PROPERTIES IMPORTED_LOCATION "${_FFMPEG_SO}")

# AGP does not package IMPORTED .so; copy next to CMake-built libs for merge into APK.
if(CMAKE_LIBRARY_OUTPUT_DIRECTORY)
    set(_FFMPEG_PACK "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libijkffmpeg.so")
    add_custom_command(
        OUTPUT "${_FFMPEG_PACK}"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_FFMPEG_SO}" "${_FFMPEG_PACK}"
        DEPENDS "${_FFMPEG_SO}"
        COMMENT "Pack libijkffmpeg.so for APK (${ANDROID_ABI})"
    )
    add_custom_target(ijkffmpeg_pack DEPENDS "${_FFMPEG_PACK}")
endif()

set(IJK_FFMPEG_INCLUDE_DIR "${FFMPEG_DIR}/include")
if(NOT EXISTS "${IJK_FFMPEG_INCLUDE_DIR}/libavutil/avconfig.h")
    message(FATAL_ERROR
        "FFmpeg headers missing at ${IJK_FFMPEG_INCLUDE_DIR}. "
        "Copy FFmpeg output to prebuilt/ffmpeg/<arch>/ (see prebuilt/README.md, tools/sync-ffmpeg-prebuilt.ps1).")
endif()
