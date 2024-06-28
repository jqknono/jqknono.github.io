---
title: vs-remote-debug
---

# remote debug with visual studio

远程调试C++:
https://docs.microsoft.com/en-us/visualstudio/debugger/remote-debugging-cpp?view=vs-2019


Attach调试:
https://docs.microsoft.com/en-us/visualstudio/debugger/attach-to-running-processes-with-the-visual-studio-debugger?view=vs-2019

配置联调程序为service:
https://docs.microsoft.com/en-us/visualstudio/debugger/remote-debugging?view=vs-2019#bkmk_configureService

如何配置启动参数:
https://stackoverflow.com/questions/6740422/visual-studio-remote-debugging-a-service

可用参数:
https://social.msdn.microsoft.com/Forums/vstudio/en-US/174c2039-b316-455a-800e-18c0d93b74bc/visual-studio-2010-remote-debugger-settings-dont-persist?forum=vsdebug

自己添加任务

"C:\Program Files\Microsoft Visual Studio 16.0\Common7\IDE\Remote Debugger\x64\msvsmon.exe"

启动参数

/noauth /anyuser /port:4045 /nosecuritywarn /timeout 360000


开发机连接: test0.jqknono.com:4045

远程访问(需提前开启开发者模式): http://test0.jqknono.com:50080/
