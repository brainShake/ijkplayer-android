set(_YUV_DIR "${IJKMEDIA_DIR}/ijkyuv")
set(_YUV_SRC
    ${_YUV_DIR}/source/compare.cc
    ${_YUV_DIR}/source/compare_common.cc
    ${_YUV_DIR}/source/compare_posix.cc
    ${_YUV_DIR}/source/convert.cc
    ${_YUV_DIR}/source/convert_argb.cc
    ${_YUV_DIR}/source/convert_from.cc
    ${_YUV_DIR}/source/convert_from_argb.cc
    ${_YUV_DIR}/source/convert_to_argb.cc
    ${_YUV_DIR}/source/convert_to_i420.cc
    ${_YUV_DIR}/source/cpu_id.cc
    ${_YUV_DIR}/source/format_conversion.cc
    ${_YUV_DIR}/source/planar_functions.cc
    ${_YUV_DIR}/source/rotate.cc
    ${_YUV_DIR}/source/rotate_argb.cc
    ${_YUV_DIR}/source/rotate_mips.cc
    ${_YUV_DIR}/source/row_any.cc
    ${_YUV_DIR}/source/row_common.cc
    ${_YUV_DIR}/source/row_mips.cc
    ${_YUV_DIR}/source/row_posix.cc
    ${_YUV_DIR}/source/scale.cc
    ${_YUV_DIR}/source/scale_argb.cc
    ${_YUV_DIR}/source/scale_common.cc
    ${_YUV_DIR}/source/scale_mips.cc
    ${_YUV_DIR}/source/scale_posix.cc
    ${_YUV_DIR}/source/video_common.cc
)
if(ANDROID_ABI STREQUAL "armeabi-v7a")
    list(APPEND _YUV_SRC
        ${_YUV_DIR}/source/compare_neon.cc
        ${_YUV_DIR}/source/rotate_neon.cc
        ${_YUV_DIR}/source/row_neon.cc
        ${_YUV_DIR}/source/scale_neon.cc
    )
    set(_YUV_NEON_FLAGS -DLIBYUV_NEON -mfpu=neon)
elseif(ANDROID_ABI STREQUAL "arm64-v8a")
    list(APPEND _YUV_SRC
        ${_YUV_DIR}/source/compare_neon64.cc
        ${_YUV_DIR}/source/rotate_neon64.cc
        ${_YUV_DIR}/source/row_neon64.cc
        ${_YUV_DIR}/source/scale_neon64.cc
    )
    set(_YUV_NEON_FLAGS -DLIBYUV_NEON)
endif()

add_library(yuv_static STATIC ${_YUV_SRC})
target_include_directories(yuv_static PUBLIC ${_YUV_DIR}/include)
target_compile_options(yuv_static PRIVATE ${_YUV_NEON_FLAGS})
