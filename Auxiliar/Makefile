all: clean compile clean

compile: randVHDL.o 
	@gcc -o memCreator randVHDL.o -lm

randVHDL.o:
	@gcc -c randVHDL.c

clean:
	@find -name '*~' | xargs rm -rf {}
	@find -name '*.o' | xargs rm -rf {}

run:
	@./memCreator

zip:
	zip -r memCreator *.c *.h Makefile
