#include <string>
#include <iostream>
#include <locale>

using namespace std;

class PipeServer
{
public:
    static PipeServer &getInstance()
    {
        static PipeServer instance;
        return instance;
    }
    bool remote_access_enabled = false;
    PipeServer(PipeServer const &) = delete;
    void operator=(PipeServer const &) = delete;

    void getPipName(string &name);

private:
    PipeServer(){};
};

void PipeServer::getPipName(std::string &name)
{
    char computer_name[] = "你好";
    name = string(computer_name);
}

int main()
{
    PipeServer &server = PipeServer::getInstance();
    string name;
    server.getPipName(name);

    cout << name << endl;
}