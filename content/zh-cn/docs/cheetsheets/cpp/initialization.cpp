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

A::A()
{
    a = -1;
}

A::A(int a) : a(a + 10)
{
}

A::A(const A &a)
{
    this->a = a.a + 10;
}

A::~A()
{
    a -= 10;
}

class B
{
public:
    uint16_t a;
    uint16_t b;
};

int main(int argc, char *argv[])
{
    A a1;
    cout << "a1.a:" << a1.a << endl;

    A a2 = a1;
    cout << "a2.a:" << a2.a << endl;

    A a3(a2);
    cout << "a3.a:" << a3.a << endl;

    A a4(a3);
    cout << "a4.a:" << a4.a << endl;

    A a5(a4.a);
    cout << "a5.a:" << a5.a << endl;

    B b1{1, 2};
    cout << b1.a << b1.b << endl;

    B b2{'a', 'b'};
    cout << b2.a << b2.b << endl;

    // stack
    uint32_t t1 = 0x12345678;
    uint32_t *pt1 = &t1;
    B *b3 = reinterpret_cast<B *>(pt1);
    cout << "b3:" << hex << b3->a << endl
         << b3->b << endl;

    // heap
    uint32_t *t2 = new uint32_t(0x12345678);
    B *b4 = reinterpret_cast<B *>(t2);
    cout << "b4:" << hex << b4->a << endl
         << b4->b << endl;
}