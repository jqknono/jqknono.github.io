#include <iostream>

using namespace std;

int main()
{
    cout << "sizeof(uint8_t) = " << sizeof(uint8_t) << endl;
    cout << "sizeof(uint16_t) = " << sizeof(uint16_t) << endl;
    cout << "sizeof(uint32_t) = " << sizeof(uint32_t) << endl;
    cout << "sizeof(uint64_t) = " << sizeof(uint64_t) << endl;

    uint8_t a = 0x5a;
    uint16_t b = 0x5a5a;
    uint32_t c = 0x5a5a5a5a;
    uint64_t d = 0x5a5a5a5a5a5a5a5a;

    cout << "a = " << static_cast<uint8_t>(a) << endl;
    cout << "a = " << static_cast<uint16_t>(a) << endl;
    cout << "a = " << static_cast<uint32_t>(a) << endl;
    cout << "a = " << static_cast<uint64_t>(a) << endl;

    cout << "b = " << static_cast<uint8_t>(b) << endl;
    cout << "b = " << static_cast<uint16_t>(b) << endl;
    cout << "b = " << static_cast<uint32_t>(b) << endl;
    cout << "b = " << static_cast<uint64_t>(b) << endl;

    cout << "c = " << static_cast<uint8_t>(c) << endl;
    cout << "c = " << static_cast<uint16_t>(c) << endl;
    cout << "c = " << static_cast<uint32_t>(c) << endl;
    cout << "c = " << static_cast<uint64_t>(c) << endl;

    cout << "d = " << static_cast<uint8_t>(d) << endl;
    cout << "d = " << static_cast<uint16_t>(d) << endl;
    cout << "d = " << static_cast<uint32_t>(d) << endl;
    cout << "d = " << static_cast<uint64_t>(d) << endl;
}