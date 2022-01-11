class A
{
public:
    int a;

protected:
    int aa;

private:
    int aaa;
};

class B
{
public:
    int b;

protected:
    int bb;

private:
    int bbb;
};

// 公有继承（public）：当一个类派生自公有基类时，基类的公有成员也是派生类的公有成员，基类的保护成员也是派生类的保护成员，
// 基类的私有成员不能直接被派生类访问，但是可以通过调用基类的公有和保护成员来访问。
// 保护继承（protected）： 当一个类派生自保护基类时，基类的公有和保护成员将成为派生类的保护成员。
// 私有继承（private）：当一个类派生自私有基类时，基类的公有和保护成员将成为派生类的私有成员。
class C : public A, protected B
{
public:
    int c;
    C createC();

protected:
    int cc;

private:
    int ccc;
};

C C::createC()
{
    C c;
    c.a = 1;
    c.aa = 2;
    c.aaa = 3; // private A
    c.b = 4;
    c.bb = 5;
    c.bbb = 6; // private A
    c.c = 7;
    c.cc = 8;
    c.ccc = 9;
    return c;
}

int main()
{
    C c;
    c.a = 1;
    c.aa = 2;  // protected A
    c.aaa = 3; // private A
    c.b = 4;   // protected B
    c.bb = 5;  // protected B
    c.bbb = 6; // private B
    c.c = 7;
    c.cc = 8;  // protected C
    c.ccc = 9; // private C
    return 0;
}