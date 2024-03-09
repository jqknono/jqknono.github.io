#include <stdio.h>
#include <iostream>
#include <Windows.h>
#include <WinCon.h>

using namespace std;

int main() {
    // 输出中文
    wstring hello1 = L"哈哈";

    UINT cp1 = GetConsoleCP();
    cout << "GetConsoleCP:" << cp1 << endl;
    UINT cp2 = GetConsoleOutputCP();
    cout << "GetConsoleOutputCP:" << cp2 << endl;

    //setlocale(LC_ALL, "chs");
    // 936 65001
    SetConsoleCP(936);
    SetConsoleOutputCP(936);
    
    //locale::global(locale("zh-CN"));
    locale loc("zh-CN");
    wcout.imbue(loc);

    cp1 = GetConsoleCP();
    cout << "GetConsoleCP:" << cp1 << endl;
    cp2 = GetConsoleOutputCP();
    cout << "GetConsoleOutputCP:" << cp2 << endl;


    wcout << hello1 << endl;
    wcout << L"呵呵" << endl;
    wcout << "呵呵" << endl;
}