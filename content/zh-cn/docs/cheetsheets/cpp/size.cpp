#include <string>
#include <unordered_set>
#include <iostream>

using namespace std;

void sizeof_array()
{
    int *a = new int[5];
    // cannot get length of pointer
    cout << "sizeof(a) = " << sizeof(a) << endl;
    cout << "sizeof(*a) = " << sizeof(*a) << endl;

    int b[] = {1, 2, 3, 4, 5};
    // get length of array
    cout << "sizeof(b) = " << sizeof(b) << endl;
    cout << "sizeof(*b) = " << sizeof(*b) << endl;

    delete[] a;
}

class Person
{
public:
    int age;
};

void sizeof_person()
{
    cout << "sizeof(Person) = " << sizeof(Person) << endl;
}

void sizeof_base_types()
{
    cout << "sizeof(int*) = " << sizeof(int *) << endl;
    cout << "sizeof(int) = " << sizeof(int) << endl;
    cout << "sizeof(long) = " << sizeof(long) << endl;
    cout << "sizeof(long long) = " << sizeof(long long) << endl;
    cout << "sizeof(float) = " << sizeof(float) << endl;
    cout << "sizeof(double) = " << sizeof(double) << endl;
    cout << "sizeof(long double) = " << sizeof(long double) << endl;
    cout << "sizeof(char) = " << sizeof(char) << endl;
    cout << "sizeof(wchar_t) = " << sizeof(wchar_t) << endl;
    cout << "sizeof(char16_t) = " << sizeof(char16_t) << endl;
    cout << "sizeof(char32_t) = " << sizeof(char32_t) << endl;
    cout << "sizeof(bool) = " << sizeof(bool) << endl;
    cout << "sizeof(short) = " << sizeof(short) << endl;
    cout << "sizeof(string) = " << sizeof(string) << endl;
}

int main()
{
    sizeof_base_types();
    sizeof_array();
    sizeof_person();
}