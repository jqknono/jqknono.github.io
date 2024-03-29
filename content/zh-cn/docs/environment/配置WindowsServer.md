---
title: 配置WindowsServer
---

# 配置 WindowsServer

## 激活

```ps1
slmgr /ipk N69G4-B89J2-4G8F4-WWYCC-J464C
slmgr /skms kms.03k.org
slmgr /ato
slmgr /xpr
```

kms 服务器, 挑一个能 ping 通的就行

zh.us.to
kms.03k.org
kms.chinancce.com
kms.shuax.com
kms.dwhd.org
kms.luody.info
kms.digiboy.ir
kms.lotro.cc
ss.yechiu.xin
www.zgbs.cc
cy2617.jios.org

激活失败处理:

1）安装的 os 为全英文版，时区默认配置为 us 时区，需要检查修改时区为中国北京时区；
2）执行事件同步，可与外网同步或内网 ad 或其他时钟源同步；或执行命令 w32tm /resync
3）再次执行：slmgr /ato，即可认证成功；
4）注意客户端与 kms 服务器属于时间一致性强依赖。默认 kms 激活时间为 180 天。
