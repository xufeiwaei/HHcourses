#ifndef TONE_H
#define TONE_H
typedef struct
{
  Object super;
  Piezo *piezo;
  int frequency;
} Tone;

#define initTone(piezoelement,frequency)   {initObject(),piezoelement,frequency}

int playing(Tone *self, int nothing);
int start_playing(Tone *self, int nothing);
int stop_playing(Tone *self, int nothing);
int setFrequency(Tone *self, int frequency);
#endif
