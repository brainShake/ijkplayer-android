# NDK cpufeatures (replaces import-module android/cpufeatures)
set(_CPUFEATURES_DIR "${CMAKE_ANDROID_NDK}/sources/android/cpufeatures")
add_library(cpufeatures STATIC "${_CPUFEATURES_DIR}/cpu-features.c")
target_include_directories(cpufeatures PUBLIC "${_CPUFEATURES_DIR}")
