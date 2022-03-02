
```
/etc/ssh/sshd_config

...STUFF ABOVE THIS...
Port 2222
#AddressFamily any
ListenAddress 0.0.0.0
#ListenAddress ::

...STUFF BELOW  THIS...
```

```shell
sudo apt install openssh-server
sudo nano /etc/ssh/sshd_config

service ssh start
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=2222 connectaddress=172.23.129.80 connectport=2222
netsh advfirewall firewall add rule name="Open Port 2222 for WSL2" dir=in action=allow protocol=TCP localport=2222
netsh interface portproxy show v4tov4
netsh int portproxy reset all
```