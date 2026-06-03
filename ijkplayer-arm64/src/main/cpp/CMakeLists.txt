cmake_minimum_required(VERSION 3.10.2)
get_filename_component(IJK_CMAKE_ROOT "${CMAKE_CURRENT_LIST_DIR}/../../../../ijkmedia/cmake" ABSOLUTE)
set(IJK_MODULE_JNI_DIR "${CMAKE_CURRENT_LIST_DIR}/../jni")
include(${IJK_CMAKE_ROOT}/IjkAndroid.cmake)
