#include "ijksoundtouch_wrap.h"

void *ijk_soundtouch_create(void)
{
    return (void *) 1;
}

void ijk_soundtouch_destroy(void *handle)
{
    (void) handle;
}

int ijk_soundtouch_translate(void *handle, short *data, float speed, float pitch,
        int len, int bytes_per_sample, int channels, int sample_rate)
{
    (void) handle;
    (void) data;
    (void) speed;
    (void) pitch;
    (void) bytes_per_sample;
    (void) channels;
    (void) sample_rate;
    return len;
}
