#include <iostream>

using namespace std;

class A
{
public:
    int a;
    A() : a(0){};
    A(int ia) : a(ia)
    {
    }

protected:
    int aa;

private:
    int aaa;
};

class B
{
public:
    int b;
    B();

protected:
    int bb;

private:
    int bbb;
};

B::B()
{
    b = 0;
    bb = 0;
    bbb = 0;
}

// 公有继承（public）：当一个类派生自公有基类时，基类的公有成员也是派生类的公有成员，基类的保护成员也是派生类的保护成员，
// 基类的私有成员不能直接被派生类访问，但是可以通过调用基类的公有和保护成员来访问。
// 保护继承（protected）： 当一个类派生自保护基类时，基类的公有和保护成员将成为派生类的保护成员。
// 私有继承（private）：当一个类派生自私有基类时，基类的公有和保护成员将成为派生类的私有成员。
class C : public A, protected B
{
public:
    int c;
    C();
    C(int c1, int c2, int c3)
    {
        a = c1;
    }

protected:
    int cc;

private:
    int ccc;
};

C::C()
{
    a = 1;
    aa = 2;
    // aaa = 3; // private A
    b = 4;
    bb = 5;
    // c.bbb = 6; // private A
    c = 7;
    cc = 8;
    ccc = 9;
}

int main()
{
    C c;
    c.a = 1;
    // c.aa = 2;  // protected A
    // c.aaa = 3; // private A
    // c.b = 4;   // protected B
    // c.bb = 5;  // protected B
    // c.bbb = 6; // private B
    c.c = 7;
    // c.cc = 8;  // protected C
    // c.ccc = 9; // private C
    cout << c.a << endl;
    return 0;
}