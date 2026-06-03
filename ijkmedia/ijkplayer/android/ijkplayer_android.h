/*
 * ijkplayer_android.h — Android 平台 ijkmp_android_* API 声明
 * 实现见 ijkplayer_android.c；由 ijkplayer_jni.c 的 JNI 方法调用。
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

#ifndef IJKPLAYER_ANDROID__IJKPLAYER_ANDROID_H
#define IJKPLAYER_ANDROID__IJKPLAYER_ANDROID_H

#include <jni.h>
#include "ijkplayer_android_def.h"
#include "../ijkplayer.h"

typedef struct ijkmp_android_media_format_context {
    const char *mime_type;
    int         profile;
    int         level;
} ijkmp_android_media_format_context;

/** 创建 Android 播放器；msg_loop 一般为 ijkplayer_jni.c 的 message_loop，ref_count 初始为 1 */
IjkMediaPlayer *ijkmp_android_create(int(*msg_loop)(void*));

/** 绑定 Surface / Texture 到 vout 与 pipeline，供硬解或 GLES 显示 */
void ijkmp_android_set_surface(JNIEnv *env, IjkMediaPlayer *mp, jobject android_surface);
/** 设置左右声道音量，最终作用到 AudioTrack */
void ijkmp_android_set_volume(JNIEnv *env, IjkMediaPlayer *mp, float left, float right);
/** 返回 AudioTrack 的 audio session id（音效/可视化用） */
int  ijkmp_android_get_audio_session_id(JNIEnv *env, IjkMediaPlayer *mp);
/** 注册 MediaCodec 是否可用的选择回调（可由 Java 注入策略） */
void ijkmp_android_set_mediacodec_select_callback(IjkMediaPlayer *mp, bool (*callback)(void *opaque, ijkmp_mediacodecinfo_context *mcc), void *opaque);

#endif
