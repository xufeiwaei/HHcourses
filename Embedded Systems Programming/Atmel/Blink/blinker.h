typedef struct{
	Object super;
	LCD *lcd;
	int period;
	int segment;
}Blinker;

#define initBlinker(lcd,p,s) {initObject(),lcd,p,s}

int blink(Blinker *self, int on);
int startblink(Blinker *self, int x);