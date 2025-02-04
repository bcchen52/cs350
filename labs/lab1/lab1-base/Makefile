CC=gcc
CFLAGS= -Wall -DBSD -DNDEBUG

all: flip flip.man

flip: flip.o getopt.o
	$(CC) $(CFLAGS) -o flip flip.o getopt.o

flip.man: flip.1
	nroff -man flip.1 > flip.man

flip.o: flip.c flip.h
	$(CC) $(CFLAGS) -c flip.c

getopt.o: getopt.c flip.h
	$(CC) $(CFLAGS) -c getopt.c

clean:
	rm -rf *.o flip flip.man
