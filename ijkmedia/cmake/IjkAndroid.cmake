cmake_minimum_required(VERSION 3.10.2)
project(ijk_android C CXX)

# 默认 IJKMEDIA_DIR = 本模块根目录（ijkmedia/，与已删除的 Android.mk 树一致）
if(NOT IJKMEDIA_DIR)
    get_filename_component(IJKMEDIA_DIR "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)
endif()
if(NOT EXISTS "${IJKMEDIA_DIR}/ijkplayer/ijkplayer.c")
    message(FATAL_ERROR "IJKMEDIA_DIR invalid: ${IJKMEDIA_DIR}")
endif()

set(CMAKE_C_STANDARD 99)
add_compile_options(
    -O3 -Wall -pipe -ffast-math -DANDROID -DNDEBUG
    -Wno-error=implicit-function-declaration
    -Wno-nan-infinity-disabled
    -Wno-int-conversion
    -Wno-pointer-to-int-cast
    -Wno-int-to-pointer-cast
)

set(IJK_CMAKE_DIR "${CMAKE_CURRENT_LIST_DIR}")
include(${IJK_CMAKE_DIR}/IjkCpuFeatures.cmake)
include(${IJK_CMAKE_DIR}/IjkFfmpeg.cmake)
include(${IJK_CMAKE_DIR}/IjkProfiler.cmake)
include(${IJK_CMAKE_DIR}/IjkSoundTouch.cmake)
include(${IJK_CMAKE_DIR}/IjkJ4a.cmake)
include(${IJK_CMAKE_DIR}/IjkYuv.cmake)
include(${IJK_CMAKE_DIR}/IjkSdl.cmake)
include(${IJK_CMAKE_DIR}/IjkPlayer.cmake)
