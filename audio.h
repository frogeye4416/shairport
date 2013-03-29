#ifndef _AUDIO_H
#define _AUDIO_H

#include <stdarg.h>

inline void audio_play(char* outbuf, int samples, void* priv_data);
void* audio_init(int sampling_rate);
void audio_set_volume(double vol);
void audio_deinit(void);
void print_audio_args();
void parse_audio_arg(char* arg);
#endif
