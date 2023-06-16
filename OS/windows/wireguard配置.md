# wireguard 配置

## 防火墙配置

```powershell
wireguard /installtunnelservice <wg_conf_path>
wg show
Get-NetConnectionProfile
Get-NetAdapter
Get-NetFirewallProfile
Set-NetFirewallProfile -Profile domain,public,private -DisabledInterfaceAliases <wg_config_name>
Set-NetIPInterface -ifindex <interface index> -Forwarding Enabled
New-NetFirewallRule -DisplayName "@wg1" -Direction Inbound  -RemoteAddress 10.66.66.1/24 -Action Allow
New-NetFirewallRule -DisplayName "@wg1" -Direction Outbound -RemoteAddress 10.66.66.1/24 -Action Allow
```
Set-NetIPInterface -ifindex 39 -Forwarding Enabled

```powershell
# 定位拦截原因
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable
wevtutil qe Security /q:"*[System/EventID=5152]" /c:5 /rd:true /f:text
auditpol /set /subcategory:"{0CCE9225-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
```
