add_library(ijksoundtouch STATIC "${IJKMEDIA_DIR}/ijksoundtouch/ijksoundtouch_wrap.c")
target_include_directories(ijksoundtouch PUBLIC "${IJKMEDIA_DIR}/ijksoundtouch")
