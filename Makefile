all: run



src/static/static.o: Makefile src/static/static.c
	gcc -c src/static/static.c -o src/static/static.o

src/static/libstatic.a: Makefile src/static/static.o
	ar rc src/static/libstatic.a src/static/static.o
	ranlib src/static/libstatic.a



src/dynamic/dynamic.o: Makefile src/static/static.h src/dynamic/dynamic.c
	gcc -c -fPIC -I./src/static src/dynamic/dynamic.c -o src/dynamic/dynamic.o

src/dynamic/libdynamic.so: Makefile src/dynamic/dynamic.o src/static/libstatic.a
	ld -shared src/dynamic/dynamic.o -o src/dynamic/libdynamic.so -L./src/static -lstatic --exclude-libs libstatic.a
	strip --strip-all src/dynamic/libdynamic.so



src/prog/prog.bin: Makefile src/prog/prog.c src/dynamic/dynamic.h src/dynamic/libdynamic.so
	gcc -I./src/static -I./src/dynamic src/prog/prog.c -o src/prog/prog.bin -L./src/dynamic -ldynamic



.PHONY: run
run: Makefile src/prog/prog.bin
	nm -D src/dynamic/libdynamic.so | grep hello
	LD_LIBRARY_PATH=./src/dynamic ./src/prog/prog.bin
