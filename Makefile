INC = constants.inc header.inc
SRC = main.s reset.s int16ToDecimal.s int8ToDecimal.s
OBJ = ${SRC:.s=.o}
CFG = nes.cfg

all: output.nes
	/Applications/fceux.app/Contents/MacOS/fceux output.nes

output.nes: ${CFG} ${OBJ}
	ld65 -C $(CFG) ${OBJ} -o output.nes

%.o: %.s ${SRC}
	ca65 $< -o $@

clean:
	rm *.nes *.o
