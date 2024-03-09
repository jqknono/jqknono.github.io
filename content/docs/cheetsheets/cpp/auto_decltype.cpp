#include <iostream>

using namespace std;

struct B
{
    int a;
    int b;
};

class A
{
public:
    B a;
    B b;
};

int main()
{
    A a;
    cout << "a.a.a:" << a.a.a << endl
         << "a.a.b:" << a.a.b << endl
         << "a.b.a:" << a.b.a << endl
         << "a.b.b:" << a.b.b << endl;

    decltype(a.a) c; // c is B
    cout << "c.a:" << c.a << endl
         << "c.b:" << c.b << endl;
}