# remote-debug

- [ ] 本地调试远程服务器

https://code.visualstudio.com/docs/cpp/pipe-transport

- **在 Windows 上调试 Linux 上的 C++程序**

## Debug Linux from Windows

```json
{
  "name": "Remote launch",
  "type": "cppdbg",
  "request": "launch",
  "program": "/titan/agent/titanagent",
  "args": ["-b /etc/titanagent", "-a -c -l"],
  "stopAtEntry": true,
  "cwd": "/titan/agent",
  "environment": [],
  "externalConsole": false,
  "additionalSOLibSearchPath": "/titan/agent/plugin",
  "symbolLoadInfo": {
    "loadAll": true,
    "exceptionList": ""
  },
  "pipeTransport": {
    "debuggerPath": "/usr/bin/gdb",
    "pipeProgram": "C:\\Windows\\System32\\OpenSSH\\ssh.exe",
    "pipeArgs": ["root@10.106.19.53"],
    "pipeCwd": "${cwd}"
  },
  "MIMode": "gdb",
  "setupCommands": [
    {
      "description": "为 gdb 启用整齐打印",
      "text": "-enable-pretty-printing",
      "ignoreFailures": true
    }
  ],
  "sourceFileMap": {
    "/home/code/titan-agent": "D:\\gerrit\\titan-agent",
    "/home/code/titan_client-ioc": "D:\\gerrit\\titan_client-ioc"
  }
}
```

## Debug Linux from Linux