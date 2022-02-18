// Copyright 2022 jqknono.com
#include <iostream>

using std::cout;

typedef struct Person {
    char name[20];
    int age;
} Person;

int main() {
    Person p1;
    snprintf(p1.name, sizeof(p1.name), "jqknono");
    p1.age = 20;
    printf("%s %d\n", p1.name, p1.age);

    Person p2;
    snprintf(p2.name, sizeof(p2.name), ".com");
    p2.age = 5;
    printf("%s %d\n", p2.name, p2.age);
    return 0;
}
