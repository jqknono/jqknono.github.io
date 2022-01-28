#include "stdio.h"
#include "stdlib.h"
#include "stdint.h"

void understand_chunk()
{
    uint32_t *a = (uint32_t *)malloc(sizeof(uint32_t) * 100);
    uint32_t *b = (uint32_t *)malloc(sizeof(uint32_t) * 300);
    uint32_t *d = (uint32_t *)malloc(sizeof(uint32_t) * 500);
    *a = 0x5a5a5a5a;
    *b = 0x5a5a5a5a;
    *d = 0x5a5a5a5a;
    printf("sizeof(uint32_t): %p\n", sizeof(uint32_t));
    printf("sizeof(uint32_t*): %p\n", sizeof(uint32_t *));
    printf("a: %p\n", a);
    printf("b: %p\n", b);
    printf("d: %p\n", d);

    a = (uint32_t *)((uint64_t *)a - 1);
    uint32_t *c = (uint32_t *)a;
    for (int i = 0; i < 4; i++)
    {
        printf("a[%d], %p\n", i, c[i]);
    }

    b = (uint32_t *)((uint64_t *)b - 1);
    c = (uint32_t *)b;
    for (int i = 0; i < 4; i++)
    {
        printf("b[%d], %p\n", i, c[i]);
    }

    d = (uint32_t *)((uint64_t *)d - 1);
    c = (uint32_t *)d;
    for (int i = 0; i < 4; i++)
    {
        printf("d[%d], %p\n", i, c[i]);
    }
    // 0xfffffff0 for the last 3 bit of 32bit OS is flags, 64bit for 4 bit
    printf("a, count of bytes: %d, full size bytes:%d\n", (*a & 0xfffffff0) - 16, *a - 1);
    printf("b, count of bytes: %d, full size bytes:%d\n", (*b & 0xfffffff0) - 16, *b - 1);
    printf("d, count of bytes: %d, full size bytes:%d\n", (*d & 0xfffffff0) - 16, *d - 1);
}

int main()
{
    understand_chunk();
}