# LD exported symbols demo

This repo shows how `ld` exports / hides static library symbols linked to a
dynamic library.

> **Note**
> By default, `ld` exports all symbols from linked static libraries.
> To hide symbols from a specific static library, we need to use this flag:
> `--exclude-libs libstatic.a`.

## Usage

```shell
$ make env # optional
$ make

RULE run

SYMBOLS FROM libdynamic.so (hidden libstatic.a symbols)
0000000000001020 T hello_from_dynamic

SYMBOLS FROM libdynamic_all.so
0000000000001030 T hello_from_dynamic
0000000000001050 T hello_from_static

RUN prog
Hello from prog!

CALL hello_from_dynamic FROM libdynamic.so (dynamically linked):
Hello from static!
Hello from dynamic!

CALL hello_from_static FROM libdynamic_all.so (dynamically opened):
Hello from static!
```
