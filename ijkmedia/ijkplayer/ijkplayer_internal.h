/*
 * ijkplayer_internal.h — native 播放器对象内存布局（Java mNativeMediaPlayer 指向此结构）
 *
 * 【核心】IjkMediaPlayer 是 Java 与 FFplay 之间的“句柄”：
 *   - ffplayer：真正的 FFmpeg 播放引擎 (FFPlayer)
 *   - msg_thread：运行 message_loop，向 Java 投递事件
 *   - mp_state：与 ijkplayer.h 中 MP_STATE_* 对应
 *   - weak_thiz：回调 Java 时使用的 WeakReference 全局引用
 *
 * Copyright (c) 2013 Bilibili
 * Copyright (c) 2013 Zhang Rui <bbcallen@gmail.com>
 *
 * This file is part of ijkPlayer.
 *
 * ijkPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ijkPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ijkPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#ifndef IJKPLAYER_ANDROID__IJKPLAYER_INTERNAL_H
#define IJKPLAYER_ANDROID__IJKPLAYER_INTERNAL_H

#include <assert.h>
#include "ijksdl/ijksdl.h"
#include "ff_fferror.h"
#include "ff_ffplay.h"
#include "ijkplayer.h"

struct IjkMediaPlayer {
    volatile int ref_count;       /* 引用计数，jni_get/set 时会 inc/dec */
    pthread_mutex_t mutex;        /* 保护状态与 ffplayer 操作 */
    FFPlayer *ffplayer;           /* ff_ffplay 引擎，解码/缓冲/时钟在此 */

    int (*msg_loop)(void*);       /* 消息线程入口，Android 上为 message_loop */
    SDL_Thread *msg_thread;
    SDL_Thread _msg_thread;

    int mp_state;                 /* MP_STATE_IDLE / PREPARED / STARTED ... */
    char *data_source;            /* setDataSource 传入的 URL 或路径 */
    void *weak_thiz;              /* jobject 全局引用，供 postEventFromNative */

    int restart;
    int restart_from_beginning;
    int seek_req;
    long seek_msec;
};

#endif
