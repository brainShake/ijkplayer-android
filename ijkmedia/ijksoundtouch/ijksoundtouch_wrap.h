#ifndef IJKSOUNDTOUCH_WRAP_H
#define IJKSOUNDTOUCH_WRAP_H

#ifdef __cplusplus
extern "C" {
#endif

void *ijk_soundtouch_create(void);
void ijk_soundtouch_destroy(void *handle);
int ijk_soundtouch_translate(void *handle, short *data, float speed, float pitch,
        int len, int bytes_per_sample, int channels, int sample_rate);

#ifdef __cplusplus
}
#endif

#endif
