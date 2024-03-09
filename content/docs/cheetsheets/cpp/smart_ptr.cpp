#include <iostream>
#include <memory>

using namespace std;

unique_ptr<char[]> generate_unique_array()
{
    unique_ptr<char[]> chars = make_unique<char[]>(1024);
    return chars;
}

void consume_unique_array(unique_ptr<char[]> &chars)
{
    cout << chars.get() << endl;
}

int main()
{
    shared_ptr<int> s1 = make_shared<int>(10);
    cout << *s1 << endl;

    shared_ptr<int> s2 = s1;
    cout << *s2 << endl;

    const int bufSize = 1024;
    unique_ptr<char[]> p2 = generate_unique_array();
    p2[0] = 'a';
    p2[1] = 'a';
    p2[50] = 'a';
    p2[100] = '\0';
    consume_unique_array(p2);

    return 0;
}