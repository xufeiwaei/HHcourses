#ifndef MELODY_H
#define MELODY_H
typedef struct
{
  Object super;
  Tone *tone;
  int *array_tones;
  int *array_durations;
} Melody;

#define initMelody(tone,pt,pd)   {initObject(),tone,pt,pd}

int start_playing_melody(Melody *self, int x);
int stop_playing_melody(Melody *self, int x);
#endif
