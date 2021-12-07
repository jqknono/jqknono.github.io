#include <stdio.h>
#include <string.h>

int main(int num)
{
    char *s = "-s";
    int ret = strncmp(s, "-s ", 3);
    printf("%d\n", ret);
}