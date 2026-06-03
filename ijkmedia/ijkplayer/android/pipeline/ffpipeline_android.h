/*
 * ffpipeline_android.h — Android 解码/渲染管线工厂
 *
 * 【职责】
 *   - ffpipeline_create_from_android：为 FFPlayer 创建 IJKFF_Pipeline
 *   - 绑定 SDL_Vout、Surface；创建 MediaCodec 硬解节点（见 ffpipenode_android_mediacodec_vdec）
 *   - 由 ijkplayer_android.c 在 ijkmp_android_create 时挂到 mp->ffplayer->pipeline
 *
 * Copyright (c) 2014 Bilibili
 * Copyright (c) 2014 Zhang Rui <bbcallen@gmail.com>
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

#ifndef FFPLAY__FF_FFPIPELINE_ANDROID_H
#define FFPLAY__FF_FFPIPELINE_ANDROID_H

#include <stdbool.h>
#include <jni.h>
#include "../ijkplayer_android_def.h"
#include "../../ff_ffpipeline.h"
#include "ijksdl/ijksdl_vout.h"

typedef struct FFPlayer       FFPlayer;
typedef struct IJKFF_Pipeline IJKFF_Pipeline;

IJKFF_Pipeline *ffpipeline_create_from_android(FFPlayer *ffp);

void    ffpipeline_set_vout(IJKFF_Pipeline* pipeline, SDL_Vout *vout);

int     ffpipeline_set_surface(JNIEnv *env, IJKFF_Pipeline* pipeline, jobject surface);

int     ffpipeline_lock_surface(IJKFF_Pipeline* pipeline);
int     ffpipeline_unlock_surface(IJKFF_Pipeline* pipeline);
jobject ffpipeline_get_surface_as_global_ref_l(JNIEnv *env, IJKFF_Pipeline* pipeline);
jobject ffpipeline_get_surface_as_global_ref(JNIEnv *env, IJKFF_Pipeline* pipeline);

bool    ffpipeline_is_surface_need_reconfigure_l(IJKFF_Pipeline* pipeline);
void    ffpipeline_set_surface_need_reconfigure_l(IJKFF_Pipeline* pipeline, bool need_reconfigure);

void    ffpipeline_set_mediacodec_select_callback(IJKFF_Pipeline* pipeline, bool (*callback)(void *opaque, ijkmp_mediacodecinfo_context *mcc), void *opaque);
bool    ffpipeline_select_mediacodec_l(IJKFF_Pipeline* pipeline, ijkmp_mediacodecinfo_context *mcc);

void    ffpipeline_set_volume(IJKFF_Pipeline* pipeline, float left, float right);

#endif
