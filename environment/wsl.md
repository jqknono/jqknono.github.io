# 配置 wsl


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [配置 wsl](#配置-wsl)
  - [远程访问 ssh](#远程访问-ssh)
  - [配置 wsl](#配置-wsl-1)

<!-- /code_chunk_output -->

## 远程访问 ssh

**wsl**

```shell
sudo apt install openssh-server
sudo nano /etc/ssh/sshd_config
/etc/ssh/sshd_config

...STUFF ABOVE THIS...
Port 2222
#AddressFamily any
ListenAddress 0.0.0.0
#ListenAddress ::

...STUFF BELOW  THIS...
```

**windows**

```ps1
service ssh start
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=172.23.129.80 connectport=2222
netsh advfirewall firewall add rule name="Open Port 2222 for WSL2" dir=in action=allow protocol=TCP localport=2222
netsh interface portproxy show v4tov4
netsh int portproxy reset all
```

## 配置 wsl

https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configuration-setting-for-wslconfig

```ps1
Set-Content -Path "$env:userprofile\\.wslconfig" -Value "
# Settings apply across all Linux distros running on WSL 2
[wsl2]

# Limits VM memory to use no more than 4 GB, this can be set as whole numbers using GB or MB
memory=2GB 

# Sets the VM to use two virtual processors
processors=2

# Specify a custom Linux kernel to use with your installed distros. The default kernel used can be found at https://github.com/microsoft/WSL2-Linux-Kernel
# kernel=C:\\temp\\myCustomKernel

# Sets additional kernel parameters, in this case enabling older Linux base images such as Centos 6
# kernelCommandLine = vsyscall=emulate

# Sets amount of swap storage space to 8GB, default is 25% of available RAM
swap=1GB

# Sets swapfile path location, default is %USERPROFILE%\AppData\Local\Temp\swap.vhdx
swapfile=C:\\temp\\wsl-swap.vhdx

# Disable page reporting so WSL retains all allocated memory claimed from Windows and releases none back when free
pageReporting=false

# Turn off default connection to bind WSL 2 localhost to Windows localhost
localhostforwarding=true

# Disables nested virtualization
nestedVirtualization=false

# Turns on output console showing contents of dmesg when opening a WSL 2 distro for debugging
debugConsole=true
"
```
