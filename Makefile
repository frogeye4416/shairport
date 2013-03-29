# the audio subsystem, currently supported: ao, alsa
AUDIO:=alsa

# how volume changes should be handled
# either soft for software
# or alsa to use the alsa mixer
VOL:=soft

# ----

CFLAGS+=-Wall $(shell pkg-config --cflags openssl) -DDISABLESTUFF
DEBUGCFLAGS+=-DDEBUGCTL 


ifneq ($(VOL),soft)
	USECFLAGS:=$(shell pkg-config --cflags alsa) 
	USELDFLAGS:=$(shell pkg-config --libs alsa)
else
	CFLAGS+=-DSOFT_VOL
endif

LDFLAGS+=-lm -lpthread $(shell pkg-config --libs openssl)
USECFLAGS+=$(shell pkg-config --cflags $(AUDIO)) 
USELDFLAGS+=$(shell pkg-config --libs $(AUDIO)) 
USEOBJS+=socketlib.o shairport.o alac.o hairtunes.o audio_$(AUDIO).o  vol_$(VOL).o

all: shairport

shairport: $(USEOBJS) 
	$(CC) $(CFLAGS) $(DEBUGCFLAGS) $(USECFLAGS) $(USEOBJS) -o $@ $(LDFLAGS) $(USELDFLAGS)

clean:
	-@rm -rf hairtunes shairport *.o



%.o: %.c Makefile
	$(CC) $(CFLAGS) $(DEBUGCFLAGS) -c $< -o $@


prefix=/usr/local
install: shairport
	install -D -m 0755 shairport $(DESTDIR)$(prefix)/bin/shairport

.PHONY: all clean install

.SILENT: clean

