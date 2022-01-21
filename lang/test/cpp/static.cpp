#include <iostream>

using namespace std;

class Person
{
public:
    static int count;
    Person()
    {
        count++;
    }

    static void printCount()
    {
        cout << "count = " << count << endl;
    }
};

int Person::count = 0;

int main()
{
    cout << Person::count << endl;
    Person p1;
    cout << Person::count << endl;
    Person p2;
    cout << Person::count << endl;
    return 0;
}