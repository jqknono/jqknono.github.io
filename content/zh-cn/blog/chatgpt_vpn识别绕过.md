---
layout: blog
title: ChatGPT VPN识别绕过方法
published: true
categories: 网络
tags: [网络, blog]
date: 2024-05-09 10:30:29 +0800
draft: false
toc: false
comments: false
---

如何处理 ChatGPT 报错  
"Unable to load site"  
"Please try again later, if you are using a VPN, try turning it off."  
"Check the status page for information on outages."

## 前言

![](https://s2.loli.net/2024/05/09/dT4xi1mwFgYRKhq.png)

chatgpt 目前仍然是使用体验最好的聊天机器人，但是在国内使用时，由于网络环境的限制，我们需要使用梯子来访问 chatgpt。但是 chatgpt 对梯子的检测较为严格，如果检测到使用了梯子，会直接拒绝访问。这里介绍一种绕过 chatgpt 对梯子检测的方法。

有其他人提到更换 IP 来绕过封锁, 但我们一般使用 IP 的地域已经是可以提供服务的地区, 所以这种方法并不一定是实际的拒绝服务原因.

另外有人提到梯子使用人数较多容易被识别, 劝人购买较贵的使用人数少的梯子, 这也很难成为合理理由, 在 ipv4 短缺的今天, 即便是海外, 也存在大量的社区使用 nat 分配端口, 共用一个 ipv4 的情况. chatgpt 一封就要封一大片, 作为一个被广泛使用的服务, 这样的检测设计肯定是不合理的.

对大众服务来说, 检测源 IP 一致性则更为合理. 付费梯子的特征通常是限制流量或限制网速, 因此多数使用梯子的用户选择按规则绕过. 绕过自己的运营商可直接访问的地址, 以减少流量消耗, 或者获得更快的访问速度, 仅在访问被防火墙拦截的地址时导入流量到代理. 这种访问目标服务的不同方式, 可能会造成源地址不一致. 例如访问 A 服务需要同时和域名 X 和域名 Y 进行通信, 而防火墙仅拦截了域名 X, 那么在 A 服务看到的同一请求的不同阶段的访问来源 IP 不一致.

**解决代理策略导致的源 IP 不一致问题, 即可绕过 chatgpt 的梯子识别.**

梯子规则中通常会含有`域名规则`, `IP规则`等.

我们还需要知道`域名解析`的 IP 结果是可以根据地域而变化的, 比如我在 A 地区时解析到附近的服务 IP, 在 B 地区时则解析到不同的 IP. 因此, DNS 的选择也非常重要.

## DNS 选择

现在 DNS 有很多的协议, `UDP:53` 已经是非常落后而且极不安全的协议, 我国甚至已将 DNS 服务列入企业经营中的一级条目. 这主要来源于过去几十年我国的各级运行商使用`DNS劫持`加`HTTP`塞入了大量的跳转广告, 蒙骗不少网络小白, 招致大量投诉. 尽管现在`Chrome/Edge`已经标配自动跳转`HTTPS`, 标记`HTTP`网站为不安全, 但我国还存在许多的地方小区级的网络服务提供商, 以及国内各种老版本的`Chromium`封装魔改, 导致 DNS 劫持和 HTTP 劫持仍然存在.

因此, 我们需要选择一个安全的 DNS 服务协议, 以避免 DNS 劫持. 根据个人经验, 阿里云的`223.5.5.5`体验足够好. 当然, 当我提`223.5.5.5`时, 肯定不是`UDP:53`的 alidns, 而是`DoH`或`DoT`协议. 在配置时, 你需要使用`tls://223.5.5.5`, 或者`https://dns.alidns.com/dns-query`写入配置.

alidns 服务在绝大多数时候都不会污染, 仅在少数敏感时期会出现污染, 你也可以使用我自建的长期 dns 服务`tls://dns.jqknono.com`, 上游来自`8.8.8.8`和`1.1.1.1`, 通过缓存来加速访问.

## 域名规则

首先打开的检测网页会包含检测逻辑, 通过向不同*域名*发送请求来验证源 IP, 因此这里需要保持域名代理的一致性.

chatgpt 网页访问的域名除了自己的域名`openai`外, 还有`auth0`, `cloudflare`等第三方域名.

可以手动写入以下规则:

```yaml
# openai
- DOMAIN-SUFFIX,chatgpt.com,PROXY
- DOMAIN-SUFFIX,openai.com,PROXY
- DOMAIN-SUFFIX,openai.org,PROXY
- DOMAIN-SUFFIX,auth0.com,PROXY
- DOMAIN-SUFFIX,cloudflare.com,PROXY
```

### 如何试验域名规则

上边列举的域名可能随着 ChatGPT 业务发展而有所变化, 下面说明域名的获取方法.

1. 浏览器打开 InPrivate 页面, 隐私页面可以避免缓存/cookies 等的影响
2. 按`F12`打开控制台, 选择`Network`/`网络`选项卡
3. 访问`chat.openai.com`, 或者`chatgpt.com`
4. 下图展示了这篇文章写成时 ChatGPT 使用的域名

![ChatGPT使用的域名](https://s2.loli.net/2024/05/09/SOtMedp8KrGyfzi.png)

仅添加这几个域名可能仍然不够, 这里分析访问失败的连接具体细节. 看到**challenge**的请求的**Content-Security-Policy**中含有众多域名, 我们将其一一添加到代理策略.

![Content-Security-Policy中的域名](https://s2.loli.net/2024/05/09/aYseB9Df3xQqWRz.png)

```yaml
# openai
- DOMAIN-SUFFIX,chatgpt.com,PROXY
- DOMAIN-SUFFIX,openai.com,PROXY
- DOMAIN-SUFFIX,openai.org,PROXY
- DOMAIN-SUFFIX,auth0.com,PROXY
- DOMAIN-SUFFIX,cloudflare.com,PROXY
# additional
- DOMAIN-SUFFIX,oaistatic.com,PROXY
- DOMAIN-SUFFIX,oaiusercontent.com,PROXY
- DOMAIN-SUFFIX,intercomcdn.com,PROXY
- DOMAIN-SUFFIX,intercom.io,PROXY
- DOMAIN-SUFFIX,mixpanel.com,PROXY
- DOMAIN-SUFFIX,statsigapi.net,PROXY
- DOMAIN-SUFFIX,featuregates.org,PROXY
- DOMAIN-SUFFIX,stripe.com,PROXY
- DOMAIN-SUFFIX,browser-intake-datadoghq.com,PROXY
- DOMAIN-SUFFIX,sentry.io,PROXY
- DOMAIN-SUFFIX,live.net,PROXY
- DOMAIN-SUFFIX,live.com,PROXY
- DOMAIN-SUFFIX,windows.net,PROXY
- DOMAIN-SUFFIX,onedrive.com,PROXY
- DOMAIN-SUFFIX,microsoft.com,PROXY
- DOMAIN-SUFFIX,azure.com,PROXY
- DOMAIN-SUFFIX,sharepoint.com,PROXY
- DOMAIN-SUFFIX,gstatic.com,PROXY
- DOMAIN-SUFFIX,google.com,PROXY
- DOMAIN-SUFFIX,googleapis.com,PROXY
- DOMAIN-SUFFIX,googleusercontent.com,PROXY
```

## IP 规则

如果上述步骤尝试后仍然不能访问*chatgpt.com*, 则可能还存在基于*IP*的检测行为, 以下是我在连接跟踪中尝试出的一些 IP, 你可以自行尝试使用, 需要说明这些 IP 并不一定适用于每个地区, 你或许需要自行尝试.

```yaml
# openai
- IP-CIDR6,2606:4700:4400::6812:231c/96,PROXY
- IP-CIDR,17.253.84.253/24,PROXY
- IP-CIDR,172.64.152.228/24,PROXY
- IP-CIDR,104.18.35.28/16,PROXY
```

### 如何试验 IP 规则

你需要了解自己的梯子客户端工具, 在连接跟踪显示页面, 观察新增的连接, 通过这些连接的 IP 地址来尝试添加规则.

以下是简单的步骤描述:

1. 浏览器打开 InPrivate 页面, 隐私页面可以避免缓存/cookies 等的影响
2. 访问`chat.openai.com`, 或者`chatgpt.com`
3. 梯子客户端中观察新增连接, 将这些连接加入到代理规则

## 协议规则

`QUIC`是基于`UDP`的加密协议, chatgpt 大量使用了 _QUIC_ 流量, 因此梯子的服务端/客户端需要支持 UDP 代理, 有许多梯子是不支持 UDP 的, 这也是导致 chatgpt 无法访问的原因之一. 客户端和服务端都支持 UDP, 还需要用户明确配置, 一些客户端会配置默认不代理 UDP 流量. 如果对 UDP 设置不熟悉, 可以设置屏蔽代理客户端的 QUIC 流量, 或者在浏览器设置屏蔽 QUIC. 浏览器发现 QUIC 不通会自动切换到基于 _TCP_ 的 HTTP/2. QUIC 是基于 UDP 的加密协议, 多数时候可以获得更流畅的体验, 有兴趣的可以自行尝试.

![](https://s2.loli.net/2024/05/09/UAzbdgQT1y5J63w.png)

## 最简单配置--白名单模式

配置仅中国 IP 直连, 未匹配到的流量走代理, 这样可以保证 chatgpt 的访问, 也可以保证其他国外服务的访问.

这种方式的缺点就是流量消耗大, 网络流畅度体验依赖梯子的网络质量, 如果您对自己的梯子有信心, 可以尝试这种方式.

当然, 您还得记得开启`UDP`代理.
