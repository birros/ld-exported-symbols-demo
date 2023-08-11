#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>
#include "dynamic.h"

#define LOG(msg)                      \
    {                                 \
        fprintf(stdout, "%s\n", msg); \
    }
#define LOG_CALL(msg)                                \
    {                                                \
        fprintf(stdout, "\033[33m%s\033[0m\n", msg); \
    }

#define FATAL(msg)                    \
    {                                 \
        fprintf(stderr, "%s\n", msg); \
        exit(EXIT_FAILURE);           \
    }

int main()
{
    {
        LOG("Hello from prog!");
    }

    {
        LOG_CALL("\nCALL hello_from_dynamic FROM libdynamic.so (dynamically linked):");
        hello_from_dynamic();
    }

    {
        void *libhandle = dlopen("libdynamic_all.so", RTLD_LAZY);
        if (libhandle == NULL)
        {
            FATAL(dlerror());
        }

        void (*hello_from_static)();
        hello_from_static = dlsym(libhandle, "hello_from_static");
        if (hello_from_static == NULL)
        {
            FATAL(dlerror());
        }

        LOG_CALL("\nCALL hello_from_static FROM libdynamic_all.so (dynamically opened):");
        hello_from_static();
    }

    return EXIT_SUCCESS;
}
