#gawk sort order
export LC_CTYPE=C

.SUFFIXES: .asm .o .gbc

all: skxs.gbc

skxs.o: skxs.asm
	rgbasm -o skxs.o skxs.asm

skxs.gbc: skxs.o
	rgblink -o $@ $<
	rgbfix -c -v -k A7 -l 0x33 -m 0x1b -p 0 -r 1 -t "TIMER MONSTER  " $@
	cmp baserom.gbc $@

clean:
	rm -f skxs.o skxs.gbc
