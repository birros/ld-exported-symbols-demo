docker compose run --rm --build -ti app bash

nm -D src/bar/libbar.so | grep hello
