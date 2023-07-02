# wireguard 搭建

下载地址:

## install

```bash
sudo apt install wireguard openresolv
sudo install -o root -g root -m 600 <username>.conf /etc/wireguard/wg0.conf

# Start the WireGuard VPN:
sudo systemctl start wg-quick@wg0

# Check that it started properly:
sudo systemctl status wg-quick@wg0

# Verify the connection to the AlgoVPN:
sudo wg

# Optionally configure the connection to come up at boot time:
sudo systemctl enable wg-quick@wg0
```

## WireGuard over TCP

https://gist.github.com/insdavm/90cbeffe76ba4a51251d83af604adf94

```bash
sudo apt install udptunnel
udptunnel -s 8080 127.0.0.1/52630

```
