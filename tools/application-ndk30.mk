# Shared NDK r25+ Application.mk (clang, c++_static). Set APP_ABI per module.
APP_OPTIM := release
APP_PLATFORM := android-21
APP_STL := c++_static
APP_CFLAGS := -O3 -Wall -pipe \
    -ffast-math \
    -Wno-psabi \
    -DANDROID -DNDEBUG
