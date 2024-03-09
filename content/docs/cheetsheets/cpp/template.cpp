#include <string>
#include <iostream>

template <class T>
T GetMax(T a, T b)
{
    return (a > b ? a : b);
}

template <class T>
class mypair
{
public:
    T values[2];
    mypair(T first, T second)
    {
        values[0] = first;
        values[1] = second;
    }
};

int main()
{
    int a = GetMax(1, 2);
    double b = GetMax(1.1, 2.2);
    std::string c = GetMax("abc", "def");
    std::cout << a << " " << b << " " << c << std::endl;

    mypair<int> p(1.1, 2);
    std::cout << p.values[0] << " " << p.values[1] << std::endl;
    return 0;
}
