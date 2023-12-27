cat << EOF > /tmp/hello.c
#include <stdio.h>

int main() {
   printf("Hello, World from C!\n");
   return 0;
}

EOF


gcc -o /tmp/hello /tmp/hello.c