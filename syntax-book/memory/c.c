#include "stdio.h"

typedef struct tagWINDOWPOS
{
    int *hwnd;
    int *hwndInsertAfter;
    int x;
    int y;
    int cx;
    int cy;
    int flags;
} WINDOWPOS;

int main()
{
    WINDOWPOS t;
    t.flags = 0xffff;
    printf("%s:%d\n", "sizeof(WINDOWPOS)",sizeof(WINDOWPOS));
    printf("flags正常排列: %x\n", *(((int *)(&t)) + 8));
    printf("最后四字节为补位, %x\n", *(((int *)(&t)) + 9));
}