#include <iostream>
#include <cstddef>

using namespace std;

int main()
{
    cout << sizeof(int) << endl;
    cout << alignof(int) << endl;

    cout << sizeof(int*) << endl;
    cout << alignof(int*) << endl;

    std::cout << alignof(std::max_align_t) << '\n';

    cout << __cplusplus << endl;
}