#include <iostream>

using namespace std;

class A
{
public:
    A();
    A(int a);
    A(const A &a);
    ~A();
    unsigned int a;
};

void funcA(int &a)
{
    a = a + 10;
}

void funcB(int *a)
{
    *a = *a + 10;
    *(a + 1) = *(a + 1) + 20;
}

void funcC0(int *a)
{
    // pointer's valus was copied in, any change to the pointer's value will not affect the original value
    // so the memory a would LEAK
    a = new int[10]{};
    a[0] = 1;
    a[1] = 2;
}

void funcC1(int *&a)
{
    a = new int[10]{};
    a[0] = 1;
    a[1] = 2;
}

void funcC2(int **a)
{
    *a = new int[10]{};
    (*a)[0] = 3;
    // *a[1] = 4;   // error
    (*a)[1] = 4;
}

int main()
{
    int *a = new int[10]{}; // initialize array
    int *b = new int[10];   // non-initialize array
    cout << "initialize array:" << a[0] << ":" << a[1] << endl;
    cout << "non-initialize array:" << b[0] << ":" << b[1] << ":" << b[2] << endl;

    funcA(a[0]);
    cout << "funcA(a[0]):" << a[0] << ":" << a[1] << endl;

    funcB(a);
    cout << "funcB(a[0]):" << a[0] << ":" << a[1] << endl;

    int *c;
    cout << "funcC0:" << c << endl;
    funcC0(c);
    cout << "funcC0:" << c << endl;
    // cout << "funcC(c[0]):" << c[0] << ":" << c[1] << endl;   // memory read out of bounds

    funcC1(c);
    cout << "funcC1:" << c << endl;
    cout << "funcC1(c):" << c[0] << ":" << c[1] << endl;

    funcC2(&c);
    cout << "funcC2:" << c << endl;
    cout << "funcC2(&c):" << c[0] << ":" << c[1] << endl;

    delete[] a;
    delete[] b;
    delete[] c;
}