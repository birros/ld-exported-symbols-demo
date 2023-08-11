#include <stdio.h>
#include "static.h"

void hello_from_dynamic() {
    hello_from_static();
    printf("Hello from dynamic!\n");
}
