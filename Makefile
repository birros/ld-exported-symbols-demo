all: run

# env
.PHONY: env
env:
	docker compose run --rm --build -ti app bash

# static
src/static/static.o: Makefile src/static/static.c
	@echo "\n\033[32mRULE\033[0m $@\n"

	gcc -c src/static/static.c -o src/static/static.o

src/static/libstatic.a: Makefile src/static/static.o
	@echo "\n\033[32mRULE\033[0m $@\n"

	ar rc src/static/libstatic.a src/static/static.o
	ranlib src/static/libstatic.a

# dynamic
src/dynamic/dynamic.o: Makefile src/static/static.h src/dynamic/dynamic.c
	@echo "\n\033[32mRULE\033[0m $@\n"

	gcc -c -fPIC -I./src/static src/dynamic/dynamic.c -o src/dynamic/dynamic.o

src/dynamic/libdynamic.so: Makefile src/dynamic/dynamic.o src/static/libstatic.a
	@echo "\n\033[32mRULE\033[0m $@\n"

	ld -shared src/dynamic/dynamic.o -o src/dynamic/libdynamic.so -L./src/static -lstatic --exclude-libs libstatic.a
	strip --strip-all src/dynamic/libdynamic.so

src/dynamic/libdynamic_all.so: Makefile src/dynamic/dynamic.o src/static/libstatic.a
	@echo "\n\033[32mRULE\033[0m $@\n"

	ld -shared src/dynamic/dynamic.o -o src/dynamic/libdynamic_all.so -L./src/static -lstatic
	strip --strip-all src/dynamic/libdynamic_all.so

# prog
src/prog/prog.bin: Makefile src/prog/prog.c src/dynamic/dynamic.h src/dynamic/libdynamic.so
	@echo "\n\033[32mRULE\033[0m $@\n"

	gcc -I./src/dynamic src/prog/prog.c -o src/prog/prog.bin -L./src/dynamic -ldynamic

# run
.PHONY: run
run: Makefile src/prog/prog.bin src/dynamic/libdynamic.so src/dynamic/libdynamic_all.so
	@echo "\n\033[32mRULE\033[0m $@\n"

	@echo "\033[34mSYMBOLS FROM libdynamic.so (hidden libstatic.a symbols)\033[0m"
	@nm -D src/dynamic/libdynamic.so | grep hello  && echo ''

	@echo "\033[34mSYMBOLS FROM libdynamic_all.so\033[0m"
	@nm -D src/dynamic/libdynamic_all.so | grep hello && echo ''

	@echo "\033[34mRUN prog\033[0m"
	@LD_LIBRARY_PATH=./src/dynamic ./src/prog/prog.bin

.PHONY: clean
clean:
	find . -type f \( \
		-name "*.o" -o \
		-name "*.a" -o \
		-name "*.so" -o \
		-name "*.bin" \
	\) -exec rm -f {} +
