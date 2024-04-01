---
title: iptables-cheetsheet
---

iptables(8) - Linux man page
============================


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Name](#-name-)
- [Synopsis](#-synopsis-)
- [Description](#-description-)
- [Targets](#-targets-)
- [Tables](#-tables-)
- [Options](#-options-)
  - [COMMANDS](#-commands-)
  - [PARAMETERS](#-parameters-)
  - [OTHER OPTIONS](#-other-options-)
- [Match Extensions](#-match-extensions-)
  - [account](#-account-)
  - [addrtype](#-addrtype-)
  - [ah](#-ah-)
  - [childlevel](#-childlevel-)
  - [comment](#-comment-)
  - [condition](#-condition-)
  - [connbytes](#-connbytes-)
  - [connlimit](#-connlimit-)
  - [connmark](#-connmark-)
  - [connrate](#-connrate-)
  - [conntrack](#-conntrack-)
  - [dccp](#-dccp-)
  - [dscp](#-dscp-)
  - [dstlimit](#-dstlimit-)
  - [ecn](#-ecn-)
  - [esp](#-esp-)
  - [fuzzy](#-fuzzy-)
  - [hashlimit](#-hashlimit-)
  - [helper](#-helper-)
  - [icmp](#-icmp-)
  - [iprange](#-iprange-)
  - [ipv4options](#-ipv4options-)
  - [length](#-length-)
  - [limit](#-limit-)
  - [mac](#-mac-)
  - [mark](#-mark-)
  - [mport](#-mport-)
  - [multiport](#-multiport-)
  - [nth](#-nth-)
  - [osf](#-osf-)
  - [owner](#-owner-)
  - [physdev](#-physdev-)
  - [pkttype](#-pkttype-)
  - [policy](#-policy-)
  - [psd](#-psd-)
  - [quota](#-quota-)
  - [random](#-random-)
  - [realm](#-realm-)
  - [recent](#-recent-)
  - [sctp](#-sctp-)
  - [set](#-set-)
  - [state](#-state-)
  - [string](#-string-)
  - [tcp](#-tcp-)
  - [tcpmss](#-tcpmss-)
  - [time](#-time-)
  - [tos](#-tos-)
  - [ttl](#-ttl-)
  - [u32](#-u32-)
  - [udp](#-udp-)
  - [unclean](#-unclean-)
- [Target Extensions](#-target-extensions-)
  - [BALANCE](#-balance-)
  - [CLASSIFY](#-classify-)
  - [CLUSTERIP](#-clusterip-)
  - [CONNMARK](#-connmark--1)
  - [DNAT](#-dnat-)
  - [DSCP](#-dscp--1)
  - [ECN](#-ecn--1)
  - [IPMARK](#-ipmark-)
  - [IPV4OPTSSTRIP](#-ipv4optsstrip-)
  - [LOG](#-log-)
  - [MARK](#-mark--1)
  - [MASQUERADE](#-masquerade-)
  - [MIRROR](#-mirror-)
  - [NETMAP](#-netmap-)
  - [NFQUEUE](#-nfqueue-)
  - [NOTRACK](#-notrack-)
  - [REDIRECT](#-redirect-)
  - [REJECT](#-reject-)
  - [SAME](#-same-)
  - [SET](#-set--1)
  - [SNAT](#-snat-)
  - [TARPIT](#-tarpit-)
  - [TCPMSS](#-tcpmss--1)
  - [TOS](#-tos--1)
  - [TRACE](#-trace-)
  - [TTL](#-ttl--1)
  - [ULOG](#-ulog-)
  - [XOR](#-xor-)
- [Diagnostics](#-diagnostics-)
- [Bugs](#-bugs-)
- [Compatibility With Ipchains](#-compatibility-with-ipchains-)
- [See Also](#-see-also-)
- [Authors](#-authors-)

<!-- /code_chunk_output -->

[[理解iptables]]

## Name

iptables - administration tool for IPv4 packet filtering and NAT

## Synopsis

**iptables [-t table] -[AD]** chain rule-specification [options] **iptables [-t table] -I** chain [rulenum] rule-specification [options] **iptables [-t table] -R** chain rulenum rule-specification [options] **iptables [-t table] -D** chain rulenum [options] **iptables [-t table] -[LFZ]** [chain] [options] **iptables [-t table] -N** chain **iptables [-t table] -X** [chain] **iptables [-t table] -P** chain target [options] **iptables [-t table] -E** old-chain-name new-chain-name

## Description

**Iptables** is used to set up, maintain, and inspect the tables of IP packet filter rules in the Linux kernel. Several different tables may be defined. Each table contains a number of built-in chains and may also contain user-defined chains.

Each chain is a list of rules which can match a set of packets. Each rule specifies what to do with a packet that matches. This is called a 'target', which may be a jump to a user-defined chain in the same table.

## Targets

A firewall rule specifies criteria for a packet, and a target. If the packet does not match, the next rule in the chain is the examined; if it does match, then the next rule is specified by the value of the target, which can be the name of a user-defined chain or one of the special values *ACCEPT*, *DROP*, *QUEUE*, or *RETURN*.

*ACCEPT* means to let the packet through. *DROP* means to drop the packet on the floor. *QUEUE* means to pass the packet to userspace. (How the packet can be received by a userspace process differs by the particular queue handler. 2.4.x and 2.6.x kernels up to 2.6.13 include the **ip_queue** queue handler. Kernels 2.6.14 and later additionally include the **nfnetlink_queue** queue handler. Packets with a target of QUEUE will be sent to queue number '0' in this case. Please also see the **NFQUEUE** target as described later in this man page.) *RETURN* means stop traversing this chain and resume at the next rule in the previous (calling) chain. If the end of a built-in chain is reached or a rule in a built-in chain with target *RETURN* is matched, the target specified by the chain policy determines the fate of the packet.

## Tables

There are currently three independent tables (which tables are present at any time depends on the kernel configuration options and which modules are present).

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>**-t, --table** *table*</dt>

<dd>This option specifies the packet matching table which the command should operate on. If the kernel is configured with automatic module loading, an attempt will be made to load the appropriate module for that table if it is not already there.

The tables are as follows:

</dd>

<dd>**filter**:</dd>

<dd>This is the default table (if no -t option is passed). It contains the built-in chains **INPUT** (for packets destined to local sockets), **FORWARD** (for packets being routed through the box), and **OUTPUT** (for locally-generated packets).</dd>

<dd>**nat**:</dd>

<dd>This table is consulted when a packet that creates a new connection is encountered. It consists of three built-ins: **PREROUTING** (for altering packets as soon as they come in), **OUTPUT** (for altering locally-generated packets before routing), and **POSTROUTING** (for altering packets as they are about to go out).</dd>

<dd>**mangle**:</dd>

<dd>This table is used for specialized packet alteration. Until kernel 2.4.17 it had two built-in chains: **PREROUTING** (for altering incoming packets before routing) and **OUTPUT** (for altering locally-generated packets before routing). Since kernel 2.4.18, three other built-in chains are also supported: **INPUT** (for packets coming into the box itself), **FORWARD** (for altering packets being routed through the box), and **POSTROUTING** (for altering packets as they are about to go out).</dd>

<dd>**raw**:</dd>

<dd>This table is used mainly for configuring exemptions from connection tracking in combination with the NOTRACK target. It registers at the netfilter hooks with higher priority and is thus called before ip_conntrack, or any other IP tables. It provides the following built-in chains: **PREROUTING** (for packets arriving via any network interface) **OUTPUT** (for packets generated by local processes)</dd>

</dl>

## Options

The options that are recognized by **iptables** can be divided into several different groups.

### COMMANDS

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>These options specify the specific action to perform. Only one of them can be specified on the command line unless otherwise specified below. For all the long versions of the command and option names, you need to use only enough letters to ensure that **iptables** can differentiate it from all other options.</dt>

<dt>**-A, --append** *chain rule-specification*</dt>

<dd>Append one or more rules to the end of the selected chain. When the source and/or destination names resolve to more than one address, a rule will be added for each possible address combination.</dd>

<dt>**-D, --delete** *chain rule-specification*</dt>

<dt>**-D, --delete** *chain rulenum*</dt>

<dd>Delete one or more rules from the selected chain. There are two versions of this command: the rule can be specified as a number in the chain (starting at 1 for the first rule) or a rule to match.</dd>

<dt>**-I, --insert** *chain* [*rulenum*] *rule-specification*</dt>

<dd>Insert one or more rules in the selected chain as the given rule number. So, if the rule number is 1, the rule or rules are inserted at the head of the chain. This is also the default if no rule number is specified.</dd>

<dt>**-R, --replace** *chain rulenum rule-specification*</dt>

<dd>Replace a rule in the selected chain. If the source and/or destination names resolve to multiple addresses, the command will fail. Rules are numbered starting at 1.</dd>

<dt>**-L, --list** [*chain*]</dt>

<dd>List all rules in the selected chain. If no chain is selected, all chains are listed. As every other iptables command, it applies to the specified table (filter is the default), so NAT rules get listed by
```
iptables -t nat -n -L
```
Please note that it is often used with the **-n** option, in order to avoid long reverse DNS lookups. It is legal to specify the **-Z** (zero) option as well, in which case the **chain**(s) will be atomically listed and zeroed. The exact output is affected by the other arguments given. The exact rules are suppressed until you use
```
iptables -L -v
```
</dd>

<dt>**-F, --flush** [*chain*]</dt>

<dd>Flush the selected chain (all the chains in the table if none is given). This is equivalent to deleting all the rules one by one.</dd>

<dt>**-Z, --zero** [*chain*]</dt>

<dd>Zero the packet and byte counters in all chains. It is legal to specify the **-L, --list** (list) option as well, to see the counters immediately before they are cleared. (See above.)</dd>

<dt>**-N, --new-chain** *chain*</dt>

<dd>Create a new user-defined chain by the given name. There must be no target of that name already.</dd>

<dt>**-X, --delete-chain** [*chain*]</dt>

<dd>Delete the optional user-defined chain specified. There must be no references to the chain. If there are, you must delete or replace the referring rules before the chain can be deleted. The chain must be empty, i.e. not contain any rules. If no argument is given, it will attempt to delete every non-builtin chain in the table.</dd>

<dt>**-P, --policy** *chain target*</dt>

<dd>Set the policy for the chain to the given target. See the section **TARGETS** for the legal targets. Only built-in (non-user-defined) chains can have policies, and neither built-in nor user-defined chains can be policy targets.</dd>

<dt>**-E, --rename-chain** *old-chain new-chain*</dt>

<dd>Rename the user specified chain to the user supplied name. This is cosmetic, and has no effect on the structure of the table.</dd>

<dt>**-h**

Help. Give a (currently very brief) description of the command syntax.

</dt>

</dl>

### PARAMETERS

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>The following parameters make up a rule specification (as used in the add, delete, insert, replace and append commands).</dt>

<dt>**-p, --protocol** [!] *protocol*</dt>

<dd>The protocol of the rule or of the packet to check. The specified protocol can be one of *tcp*, *udp*, *icmp*, or *all*, or it can be a numeric value, representing one of these protocols or a different one. A protocol name from /etc/protocols is also allowed. A "!" argument before the protocol inverts the test. The number zero is equivalent to *all*. Protocol *all* will match with all protocols and is taken as default when this option is omitted.</dd>

<dt>**-s, --source** [!] *address*[/*mask*]</dt>

<dd>Source specification. *Address* can be either a network name, a hostname (please note that specifying any name to be resolved with a remote query such as DNS is a really bad idea), a network IP address (with /mask), or a plain IP address. The *mask* can be either a network mask or a plain number, specifying the number of 1's at the left side of the network mask. Thus, a mask of *24* is equivalent to *255.255.255.0*. A "!" argument before the address specification inverts the sense of the address. The flag **--src** is an alias for this option.</dd>

<dt>**-d, --destination** [!] *address*[/*mask*]</dt>

<dd>Destination specification. See the description of the **-s** (source) flag for a detailed description of the syntax. The flag **--dst** is an alias for this option.</dd>

<dt>**-j, --jump** *target*</dt>

<dd>This specifies the target of the rule; i.e., what to do if the packet matches it. The target can be a user-defined chain (other than the one this rule is in), one of the special builtin targets which decide the fate of the packet immediately, or an extension (see **EXTENSIONS** below). If this option is omitted in a rule (and **-g** is not used), then matching the rule will have no effect on the packet's fate, but the counters on the rule will be incremented.</dd>

<dt>**-g, --goto** *chain*</dt>

<dd>This specifies that the processing should continue in a user specified chain. Unlike the --jump option return will not continue processing in this chain but instead in the chain that called us via --jump.</dd>

<dt>**-i, --in-interface** [!] *name*</dt>

<dd>Name of an interface via which a packet was received (only for packets entering the **INPUT**, **FORWARD** and **PREROUTING** chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match.</dd>

<dt>**-o, --out-interface** [!] *name*</dt>

<dd>Name of an interface via which a packet is going to be sent (for packets entering the **FORWARD**, **OUTPUT** and **POSTROUTING** chains). When the "!" argument is used before the interface name, the sense is inverted. If the interface name ends in a "+", then any interface which begins with this name will match. If this option is omitted, any interface name will match.</dd>

<dt>**[!] -f, --fragment**</dt>

<dd>This means that the rule only refers to second and further fragments of fragmented packets. Since there is no way to tell the source or destination ports of such a packet (or ICMP type), such a packet will not match any rules which specify them. When the "!" argument precedes the "-f" flag, the rule will only match head fragments, or unfragmented packets.</dd>

<dt>**-c, --set-counters** *PKTS BYTES*</dt>

<dd>This enables the administrator to initialize the packet and byte counters of a rule (during **INSERT, APPEND, REPLACE** operations).</dd>

</dl>

### OTHER OPTIONS

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>The following additional options can be specified:</dt>

<dt>**-v, --verbose**</dt>

<dd>Verbose output. This option makes the list command show the interface name, the rule options (if any), and the TOS masks. The packet and byte counters are also listed, with the suffix 'K', 'M' or 'G' for 1000, 1,000,000 and 1,000,000,000 multipliers respectively (but see the **-x** flag to change this). For appending, insertion, deletion and replacement, this causes detailed information on the rule or rules to be printed.</dd>

<dt>**-n, --numeric**</dt>

<dd>Numeric output. IP addresses and port numbers will be printed in numeric format. By default, the program will try to display them as host names, network names, or services (whenever applicable).</dd>

<dt>**-x, --exact**</dt>

<dd>Expand numbers. Display the exact value of the packet and byte counters, instead of only the rounded number in K's (multiples of 1000) M's (multiples of 1000K) or G's (multiples of 1000M). This option is only relevant for the **-L** command.</dd>

<dt>**--line-numbers**</dt>

<dd>When listing rules, add line numbers to the beginning of each rule, corresponding to that rule's position in the chain.</dd>

<dt>**--modprobe=command**</dt>

<dd>When adding or inserting rules into a chain, use **command** to load any necessary modules (targets, match extensions, etc).</dd>

</dl>

## Match Extensions

iptables can use extended packet matching modules. These are loaded in two ways: implicitly, when **-p** or **--protocol** is specified, or with the **-m** or **--match** options, followed by the matching module name; after these, various extra command line options become available, depending on the specific module. You can specify multiple extended match modules in one line, and you can use the **-h** or **--help** options after the module has been specified to receive help specific to that module.

The following are included in the base package, and most of these can be preceded by a **!** to invert the sense of the match.

### account

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Account traffic for all hosts in defined network/netmask.

Features:

- long (one counter per protocol TCP/UDP/IMCP/Other) and short statistics

- one iptables rule for all hosts in network/netmask

- loading/saving counters (by reading/writting to procfs entries)

</dt>

<dt>**--aaddr** *network/netmask*</dt>

<dd>defines network/netmask for which make statistics.</dd>

<dt>**--aname** *name*</dt>

<dd>defines name of list where statistics will be kept. If no is specified DEFAULT will be used.</dd>

<dt>**--ashort**</dt>

<dd>table will colect only short statistics (only total counters without splitting it into protocols.</dd>

<dt>Example usage:

account traffic for/to 192.168.0.0/24 network into table mynetwork:

# iptables -A FORWARD -m account --aname mynetwork --aaddr 192.168.0.0/24

account traffic for/to WWW serwer for 192.168.0.0/24 network into table mywwwserver:

# iptables -A INPUT -p tcp --dport 80 -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort

# iptables -A OUTPUT -p tcp --sport 80 -m account --aname mywwwserver --aaddr 192.168.0.0/24 --ashort

read counters:

# cat /proc/net/ipt_account/mynetwork # cat /proc/net/ipt_account/mywwwserver

set counters:

# echo "ip = 192.168.0.1 packets_src = 0" > /proc/net/ipt_account/mywwserver

Webpage: <http://www.barbara.eu.org/~quaker/ipt_account/>

</dt>

</dl>

### addrtype

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches packets based on their **address type.** Address types are used within the kernel networking stack and categorize addresses into various groups. The exact definition of that group depends on the specific layer three protocol.</dt>

<dt>The following address types are possible:</dt>

<dt>**UNSPEC**

an unspecified address (i.e. 0.0.0.0) **UNICAST** an unicast address **LOCAL** a local address **BROADCAST** a broadcast address **ANYCAST** an anycast packet **MULTICAST** a multicast address **BLACKHOLE** a blackhole address **UNREACHABLE** an unreachable address **PROHIBIT** a prohibited address **THROW** FIXME **NAT** FIXME **XRESOLVE** FIXME

</dt>

<dt>**--src-type** *type*</dt>

<dd>Matches if the source address is of given type</dd>

<dt>**--dst-type** *type*</dt>

<dd>Matches if the destination address is of given type</dd>

</dl>

### ah

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the SPIs in Authentication header of IPsec packets.</dt>

<dt>**--ahspi** [!] *spi*[:*spi*]</dt>

</dl>

### childlevel

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This is an experimental module. It matches on whether the packet is part of a master connection or one of its children (or grandchildren, etc). For instance, most packets are level 0\. FTP data transfer is level 1.</dt>

<dt>**--childlevel** [!] *level*</dt>

</dl>

### comment

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Allows you to add comments (up to 256 characters) to any rule.</dt>

<dt>**--comment** *comment*</dt>

<dt>Example:</dt>

<dd>iptables -A INPUT -s 192.168.0.0/16 -m comment --comment "A privatized IP block"</dd>

</dl>

### condition

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This matches if a specific /proc filename is '0' or '1'.</dt>

<dt>**--condition** *[!] filename*</dt>

<dd>Match on boolean value stored in /proc/net/ipt_condition/filename file</dd>

</dl>

### connbytes

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Match by how many bytes or packets a connection (or one of the two flows constituting the connection) have tranferred so far, or by average bytes per packet.

The counters are 64bit and are thus not expected to overflow ;)

The primary use is to detect long-lived downloads and mark them to be scheduled using a lower priority band in traffic control.

The transfered bytes per connection can also be viewed through /proc/net/ip_conntrack and accessed via ctnetlink

</dt>

<dt>[**!**] **--connbytes** *from***:**[*to*]</dt>

<dd>match packets from a connection whose packets/bytes/average packet size is more than FROM and less than TO bytes/packets. if TO is omitted only FROM check is done. "!" is used to match packets not falling in the range.</dd>

<dt>**--connbytes-dir** [**original**|**reply**|**both**]</dt>

<dd>which packets to consider</dd>

<dt>**--connbytes-mode** [**packets**|**bytes**|**avgpkt**]</dt>

<dd>whether to check the amount of packets, number of bytes transferred or the average size (in bytes) of all packets received so far. Note that when "both" is used together with "avgpkt", and data is going (mainly) only in one direction (for example HTTP), the average packet size will be about half of the actual data packets.</dd>

<dt>Example:</dt>

<dd>iptables .. -m connbytes --connbytes 10000:100000 --connbytes-dir both --connbytes-mode bytes ...</dd>

</dl>

### connlimit

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Allows you to restrict the number of parallel TCP connections to a server per client IP address (or address block).</dt>

<dt>[**!**] **--connlimit-above** *n*</dt>

<dd>match if the number of existing tcp connections is (not) above n</dd>

<dt>**--connlimit-mask** *bits*</dt>

<dd>group hosts using mask</dd>

<dt>Examples:</dt>

<dt># allow 2 telnet connections per client host</dt>

<dd>iptables -p tcp --syn --dport 23 -m connlimit --connlimit-above 2 -j REJECT</dd>

<dt># you can also match the other way around:</dt>

<dd>iptables -p tcp --syn --dport 23 -m connlimit ! --connlimit-above 2 -j ACCEPT</dd>

<dt># limit the nr of parallel http requests to 16 per class C sized network (24 bit netmask)</dt>

<dd>iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 16 --connlimit-mask 24 -j REJECT</dd>

</dl>

### connmark

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the netfilter mark field associated with a connection (which can be set using the **CONNMARK** target below).</dt>

<dt>**--mark** *value[/mask]*</dt>

<dd>Matches packets in connections with the given mark value (if a mask is specified, this is logically ANDed with the mark before the comparison).</dd>

</dl>

### connrate

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the current transfer rate in a connection.</dt>

<dt>**--connrate** *[!] [from]:[to]*</dt>

<dd>Match against the current connection transfer rate being within 'from' and 'to' bytes per second. When the "!" argument is used before the range, the sense of the match is inverted.</dd>

</dl>

### conntrack

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module, when combined with connection tracking, allows access to more connection tracking information than the "state" match. (this module is present only if iptables was compiled under a kernel supporting this feature)</dt>

<dt>**--ctstate** *state*</dt>

<dd>Where state is a comma separated list of the connection states to match. Possible states are **INVALID** meaning that the packet is associated with no known connection, **ESTABLISHED** meaning that the packet is associated with a connection which has seen packets in both directions, **NEW** meaning that the packet has started a new connection, or otherwise associated with a connection which has not seen packets in both directions, and **RELATED** meaning that the packet is starting a new connection, but is associated with an existing connection, such as an FTP data transfer, or an ICMP error. **SNAT** A virtual state, matching if the original source address differs from the reply destination. **DNAT** A virtual state, matching if the original destination differs from the reply source.</dd>

<dt>**--ctproto** *proto*</dt>

<dd>Protocol to match (by number or name)</dd>

<dt>**--ctorigsrc** *[!] address[/mask]*</dt>

<dd>Match against original source address</dd>

<dt>**--ctorigdst** *[!] address[/mask]*</dt>

<dd>Match against original destination address</dd>

<dt>**--ctreplsrc** *[!] address[/mask]*</dt>

<dd>Match against reply source address</dd>

<dt>**--ctrepldst** *[!] address***[/***mask***]**</dt>

<dd>Match against reply destination address</dd>

<dt>**--ctstatus** *[NONE|EXPECTED|SEEN_REPLY|ASSURED][,...]*</dt>

<dd>Match against internal conntrack states</dd>

<dt>**--ctexpire** *time[:time]*</dt>

<dd>Match remaining lifetime in seconds against given value or range of values (inclusive)</dd>

</dl>

### dccp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>**--source-port**,**--sport** [**!**] *port*[**:***port*]</dt>

<dt>**--destination-port**,**--dport** [**!**] *port*[**:***port*]</dt>

<dt>**--dccp-types** [**!**] *mask*</dt>

<dd>Match when the DCCP packet type is one of 'mask'. 'mask' is a comma-separated list of packet types. Packet types are: **REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCACK INVALID**.</dd>

<dt>**--dccp-option** [**!**] *number*</dt>

<dd>Match if DCP option set.</dd>

</dl>

### dscp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the 6 bit DSCP field within the TOS field in the IP header. DSCP has superseded TOS within the IETF.</dt>

<dt>**--dscp** *value*</dt>

<dd>Match against a numeric (decimal or hex) value [0-63].</dd>

<dt>**--dscp-class** *DiffServ Class*</dt>

<dd>Match the DiffServ class. This value may be any of the BE, EF, AFxx or CSx classes. It will then be converted into it's according numeric value.</dd>

</dl>

### dstlimit

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module allows you to limit the packet per second (pps) rate on a per destination IP or per destination port base. As opposed to the 'limit' match, every destination ip / destination port has it's own limit.</dt>

<dt>THIS MODULE IS DEPRECATED AND HAS BEEN REPLACED BY ''hashlimit''</dt>

<dt>**--dstlimit** *avg*</dt>

<dd>Maximum average match rate (packets per second unless followed by /sec /minute /hour /day postfixes).</dd>

<dt>**--dstlimit-mode** *mode*</dt>

<dd>The limiting hashmode. Is the specified limit per **dstip, dstip-dstport** tuple, **srcip-dstip** tuple, or per **srcipdstip-dstport** tuple.</dd>

<dt>**--dstlimit-name** *name*</dt>

<dd>Name for /proc/net/ipt_dstlimit/* file entry</dd>

<dt>**[***--dstlimit-burst* **burst***]*</dt>

<dd>Number of packets to match in a burst. Default: 5</dd>

<dt>**[***--dstlimit-htable-size* **size***]*</dt>

<dd>Number of buckets in the hashtable</dd>

<dt>**[***--dstlimit-htable-max* **max***]*</dt>

<dd>Maximum number of entries in the hashtable</dd>

<dt>**[***--dstlimit-htable-gcinterval* **interval***]*</dt>

<dd>Interval between garbage collection runs of the hashtable (in miliseconds). Default is 1000 (1 second).</dd>

<dt>**[***--dstlimit-htable-expire* **time**</dt>

<dd>After which time are idle entries expired from hashtable (in miliseconds)? Default is 10000 (10 seconds).</dd>

</dl>

### ecn

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This allows you to match the ECN bits of the IPv4 and TCP header. ECN is the Explicit Congestion Notification mechanism as specified in RFC3168</dt>

<dt>**--ecn-tcp-cwr**</dt>

<dd>This matches if the TCP ECN CWR (Congestion Window Received) bit is set.</dd>

<dt>**--ecn-tcp-ece**</dt>

<dd>This matches if the TCP ECN ECE (ECN Echo) bit is set.</dd>

<dt>**--ecn-ip-ect** *num*</dt>

<dd>This matches a particular IPv4 ECT (ECN-Capable Transport). You have to specify a number between '0' and '3'.</dd>

</dl>

### esp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the SPIs in ESP header of IPsec packets.</dt>

<dt>**--espspi** [!] *spi*[:*spi*]</dt>

</dl>

### fuzzy

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches a rate limit based on a fuzzy logic controller [FLC]</dt>

<dt>**--lower-limit** *number*</dt>

<dd>Specifies the lower limit (in packets per second).</dd>

<dt>**--upper-limit** *number*</dt>

<dd>Specifies the upper limit (in packets per second).</dd>

</dl>

### hashlimit

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This patch adds a new match called 'hashlimit'. The idea is to have something like 'limit', but either per destination-ip or per (destip,destport) tuple.

It gives you the ability to express

</dt>

<dd>'1000 packets per second for every host in 192.168.0.0/16'

'100 packets per second for every service of 192.168.1.1'

</dd>

<dt>with a single iptables rule.</dt>

<dt>**--hashlimit** *rate*</dt>

<dd>A rate just like the limit match</dd>

<dt>**--hashlimit-burst** *num*</dt>

<dd>Burst value, just like limit match</dd>

<dt>**--hashlimit-mode** *destip | destip-destport*</dt>

<dd>Limit per IP or per port</dd>

<dt>**--hashlimit-name** *foo*</dt>

<dd>The name for the /proc/net/ipt_hashlimit/foo entry</dd>

<dt>**--hashlimit-htable-size** *num*</dt>

<dd>The number of buckets of the hash table</dd>

<dt>**--hashlimit-htable-max** *num*</dt>

<dd>Maximum entries in the hash</dd>

<dt>**--hashlimit-htable-expire** *num*</dt>

<dd>After how many miliseconds do hash entries expire</dd>

<dt>**--hashlimit-htable-gcinterval** *num*</dt>

<dd>How many miliseconds between garbage collection intervals</dd>

</dl>

### helper

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches packets related to a specific conntrack-helper.</dt>

<dt>**--helper** *string*</dt>

<dd>Matches packets related to the specified conntrack-helper.</dd>

<dd>string can be "ftp" for packets related to a ftp-session on default port. For other ports append -portnr to the value, ie. "ftp-2121".

Same rules apply for other conntrack-helpers.

</dd>

</dl>

### icmp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This extension is loaded if '--protocol icmp' is specified. It provides the following option:</dt>

<dt>**--icmp-type** [!] *typename*</dt>

<dd>This allows specification of the ICMP type, which can be a numeric ICMP type, or one of the ICMP type names shown by the command
```
iptables -p icmp -h
```
</dd>

</dl>

### iprange

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This matches on a given arbitrary range of IPv4 addresses</dt>

<dt>**[!]***--src-range* **ip-ip**</dt>

<dd>Match source IP in the specified range.</dd>

<dt>**[!]***--dst-range* **ip-ip**</dt>

<dd>Match destination IP in the specified range.</dd>

</dl>

### ipv4options

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Match on IPv4 header options like source routing, record route, timestamp and router-alert.</dt>

<dt>**--ssrr**

To match packets with the flag strict source routing.

### --lsrr

To match packets with the flag loose source routing.

</dt>

<dt>**--no-srr**</dt>

<dd>To match packets with no flag for source routing.</dd>

<dt>[**!**] **--rr**</dt>

<dd>To match packets with the RR flag.</dd>

<dt>[**!**] **--ts**</dt>

<dd>To match packets with the TS flag.</dd>

<dt>[**!**] **--ra**</dt>

<dd>To match packets with the router-alert option.</dd>

<dt>[**!**] **--any-opt**</dt>

<dd>To match a packet with at least one IP option, or no IP option at all if ! is chosen.</dd>

<dt>Examples:</dt>

<dt>$ iptables -A input -m ipv4options --rr -j DROP</dt>

<dd>will drop packets with the record-route flag.</dd>

<dt>$ iptables -A input -m ipv4options --ts -j DROP</dt>

<dd>will drop packets with the timestamp flag.</dd>

</dl>

### length

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the length of a packet against a specific value or range of values.</dt>

<dt>**--length** [!] *length*[:*length*]</dt>

</dl>

### limit

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches at a limited rate using a token bucket filter. A rule using this extension will match until this limit is reached (unless the '!' flag is used). It can be used in combination with the **LOG** target to give limited logging, for example.</dt>

<dt>**--limit** *rate*</dt>

<dd>Maximum average matching rate: specified as a number, with an optional '/second', '/minute', '/hour', or '/day' suffix; the default is 3/hour.</dd>

<dt>**--limit-burst** *number*</dt>

<dd>Maximum initial number of packets to match: this number gets recharged by one every time the limit specified above is not reached, up to this number; the default is 5.</dd>

</dl>

### mac

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>**--mac-source** [!] *address*</dt>

<dd>Match source MAC address. It must be of the form XX:XX:XX:XX:XX:XX. Note that this only makes sense for packets coming from an Ethernet device and entering the **PREROUTING**, **FORWARD** or **INPUT** chains.</dd>

</dl>

### mark

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the netfilter mark field associated with a packet (which can be set using the **MARK** target below).</dt>

<dt>**--mark** *value*[/*mask*]</dt>

<dd>Matches packets with the given unsigned mark value (if a *mask* is specified, this is logically ANDed with the *mask* before the comparison).</dd>

</dl>

### mport

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches a set of source or destination ports. Up to 15 ports can be specified. It can only be used in conjunction with **-p tcp** or **-p udp**.</dt>

<dt>**--source-ports** *port*[,*port*[,*port*...]]</dt>

<dd>Match if the source port is one of the given ports. The flag **--sports** is a convenient alias for this option.</dd>

<dt>**--destination-ports** *port*[,*port*[,*port*...]]</dt>

<dd>Match if the destination port is one of the given ports. The flag **--dports** is a convenient alias for this option.</dd>

<dt>**--ports** *port*[,*port*[,*port*...]]</dt>

<dd>Match if the both the source and destination ports are equal to each other and to one of the given ports.</dd>

</dl>

### multiport

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches a set of source or destination ports. Up to 15 ports can be specified. A port range (port:port) counts as two ports. It can only be used in conjunction with **-p tcp** or **-p udp**.</dt>

<dt>**--source-ports** *[!] port*[,*port*[,*port:port*...]]</dt>

<dd>Match if the source port is one of the given ports. The flag **--sports** is a convenient alias for this option.</dd>

<dt>**--destination-ports** *[!] port*[,*port*[,*port:port*...]]</dt>

<dd>Match if the destination port is one of the given ports. The flag **--dports** is a convenient alias for this option.</dd>

<dt>**--ports** *[!] port*[,*port*[,*port:port*...]]</dt>

<dd>Match if either the source or destination ports are equal to one of the given ports.</dd>

</dl>

### nth

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches every 'n'th packet</dt>

<dt>**--every** *value*</dt>

<dd>Match every 'value' packet</dd>

<dt>**[***--counter* **num***]*</dt>

<dd>Use internal counter number 'num'. Default is '0'.</dd>

<dt>**[***--start* **num***]*</dt>

<dd>Initialize the counter at the number 'num' insetad of '0'. Most between '0' and 'value'-1.</dd>

<dt>**[***--packet* **num***]*</dt>

<dd>Match on 'num' packet. Most be between '0' and 'value'-1.</dd>

</dl>

### osf

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>The idea of passive OS fingerprint matching exists for quite a long time, but was created as extension fo OpenBSD pf only some weeks ago. Original idea was lurked in some OpenBSD mailing list (thanks grange@open...) and than adopted for Linux netfilter in form of this code.

Original fingerprint table was created by Michal Zalewski <<lcamtuf@coredump.cx>>.

This module compares some data(WS, MSS, options and it's order, ttl, df and others) from first SYN packet (actually from packets with SYN bit set) with dynamically loaded OS fingerprints.

</dt>

<dt>**--log 1/0**</dt>

</dl>

If present, OSF will log determined genres even if they don't match desired one.

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dd>0 - log all determined entries, 1 - only first one.</dd>

<dd>In syslog you find something like this:</dd>

<dd>ipt_osf: Windows [2000:SP3:Windows XP Pro SP1, 2000 SP3]: 11.22.33.55:4024 -> 11.22.33.44:139

ipt_osf: Unknown: 16384:106:1:48:020405B401010402 44.33.22.11:1239 -> 11.22.33.44:80

</dd>

<dt>**--smart**</dt>

<dd>if present, OSF will use some smartness to determine remote OS. OSF will use initial TTL only if source of connection is in our local network.</dd>

<dt>**--netlink**</dt>

<dd>If present, OSF will log all events also through netlink NETLINK_NFLOG groupt 1.</dd>

<dt>**--genre** *[!] string*</dt>

<dd>Match a OS genre by passive fingerprinting</dd>

<dt>Example:

#iptables -I INPUT -j ACCEPT -p tcp -m osf --genre Linux --log 1 --smart

NOTE: -p tcp is obviously required as it is a TCP match.

Fingerprints can be loaded and read through /proc/sys/net/ipv4/osf file. One can flush all fingerprints with following command:

</dt>

<dd>echo -en FLUSH > /proc/sys/net/ipv4/osf</dd>

<dt>Only one fingerprint per open/write/close.

Fingerprints can be downloaded from <http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os>

</dt>

</dl>

### owner

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module attempts to match various characteristics of the packet creator, for locally-generated packets. It is only valid in the **OUTPUT** chain, and even this some packets (such as ICMP ping responses) may have no owner, and hence never match.</dt>

<dt>**--uid-owner** *userid*</dt>

<dd>Matches if the packet was created by a process with the given effective user id.</dd>

<dt>**--gid-owner** *groupid*</dt>

<dd>Matches if the packet was created by a process with the given effective group id.</dd>

<dt>**--pid-owner** *processid*</dt>

<dd>Matches if the packet was created by a process with the given process id.</dd>

<dt>**--sid-owner** *sessionid*</dt>

<dd>Matches if the packet was created by a process in the given session group.</dd>

<dt>**--cmd-owner** *name*</dt>

<dd>Matches if the packet was created by a process with the given command name. (this option is present only if iptables was compiled under a kernel supporting this feature)</dd>

<dt>**NOTE: pid, sid and command matching are broken on SMP**</dt>

</dl>

### physdev

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches on the bridge port input and output devices enslaved to a bridge device. This module is a part of the infrastructure that enables a transparent bridging IP firewall and is only useful for kernel versions above version 2.5.44.</dt>

<dt>**--physdev-in** [!] *name*</dt>

<dd>Name of a bridge port via which a packet is received (only for packets entering the **INPUT**, **FORWARD** and **PREROUTING** chains). If the interface name ends in a "+", then any interface which begins with this name will match. If the packet didn't arrive through a bridge device, this packet won't match this option, unless '!' is used.</dd>

<dt>**--physdev-out** [!] *name*</dt>

<dd>Name of a bridge port via which a packet is going to be sent (for packets entering the **FORWARD**, **OUTPUT** and **POSTROUTING** chains). If the interface name ends in a "+", then any interface which begins with this name will match. Note that in the **nat** and **mangle OUTPUT** chains one cannot match on the bridge output port, however one can in the **filter OUTPUT** chain. If the packet won't leave by a bridge device or it is yet unknown what the output device will be, then the packet won't match this option, unless</dd>

<dt>[!] **--physdev-is-in**</dt>

<dd>Matches if the packet has entered through a bridge interface.</dd>

<dt>[!] **--physdev-is-out**</dt>

<dd>Matches if the packet will leave through a bridge interface.</dd>

<dt>[!] **--physdev-is-bridged**</dt>

<dd>Matches if the packet is being bridged and therefore is not being routed. This is only useful in the FORWARD and POSTROUTING chains.</dd>

</dl>

### pkttype

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the link-layer packet type.</dt>

<dt>**--pkt-type** *[unicast|broadcast|multicast]*</dt>

</dl>

### policy

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This modules matches the policy used by IPsec for handling a packet.</dt>

<dt>**--dir** *in|out*</dt>

<dd>Used to select whether to match the policy used for decapsulation or the policy that will be used for encapsulation. **in** is valid in the **PREROUTING, INPUT and FORWARD** chains, **out** is valid in the **POSTROUTING, OUTPUT and FORWARD** chains.</dd>

<dt>**--pol** *none|ipsec*</dt>

<dd>Matches if the packet is subject to IPsec processing.</dd>

<dt>**--strict**</dt>

<dd>Selects whether to match the exact policy or match if any rule of the policy matches the given policy.</dd>

<dt>**--reqid** *id*</dt>

<dd>Matches the reqid of the policy rule. The reqid can be specified with ****[setkey](https://linux.die.net/man/8/setkey)**(8)** using **unique:id** as level.</dd>

<dt>**--spi** *spi*</dt>

<dd>Matches the SPI of the SA.</dd>

<dt>**--proto** *ah|esp|ipcomp*</dt>

<dd>Matches the encapsulation protocol.</dd>

<dt>**--mode** *tunnel|transport*</dt>

<dd>Matches the encapsulation mode.</dd>

<dt>**--tunnel-src** *addr[/mask]*</dt>

<dd>Matches the source end-point address of a tunnel mode SA. Only valid with --mode tunnel.</dd>

<dt>**--tunnel-dst** *addr[/mask]*</dt>

<dd>Matches the destination end-point address of a tunnel mode SA. Only valid with --mode tunnel.</dd>

<dt>**--next**

Start the next element in the policy specification. Can only be used with --strict

</dt>

</dl>

### psd

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Attempt to detect TCP and UDP port scans. This match was derived from Solar Designer's scanlogd.</dt>

<dt>**--psd-weight-threshold** *threshold*</dt>

<dd>Total weight of the latest TCP/UDP packets with different destination ports coming from the same host to be treated as port scan sequence.</dd>

<dt>**--psd-delay-threshold** *delay*</dt>

<dd>Delay (in hundredths of second) for the packets with different destination ports coming from the same host to be treated as possible port scan subsequence.</dd>

<dt>**--psd-lo-ports-weight** *weight*</dt>

<dd>Weight of the packet with privileged (<=1024) destination port.</dd>

<dt>**--psd-hi-ports-weight** *weight*</dt>

<dd>Weight of the packet with non-priviliged destination port.</dd>

</dl>

### quota

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Implements network quotas by decrementing a byte counter with each packet.</dt>

<dt>**--quota** *bytes*</dt>

<dd>The quota in bytes.</dd>

<dt>KNOWN BUGS: this does not work on SMP systems.</dt>

</dl>

### random

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module randomly matches a certain percentage of all packets.</dt>

<dt>**--average** *percent*</dt>

<dd>Matches the given percentage. If omitted, a probability of 50% is set.</dd>

</dl>

### realm

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This matches the routing realm. Routing realms are used in complex routing setups involving dynamic routing protocols like BGP.</dt>

<dt>**--realm** *[!]***value[/mask]**</dt>

<dd>Matches a given realm number (and optionally mask).</dd>

</dl>

### recent

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Allows you to dynamically create a list of IP addresses and then match against that list in a few different ways.

For example, you can create a 'badguy' list out of people attempting to connect to port 139 on your firewall and then DROP all future packets from them without considering them.

</dt>

<dt>**--name** *name*</dt>

<dd>Specify the list to use for the commands. If no name is given then 'DEFAULT' will be used.</dd>

<dt>[**!**] **--set**</dt>

<dd>This will add the source address of the packet to the list. If the source address is already in the list, this will update the existing entry. This will always return success (or failure if '!' is passed in).</dd>

<dt>[**!**] **--rcheck**</dt>

<dd>Check if the source address of the packet is currently in the list.</dd>

<dt>[**!**] **--update**</dt>

<dd>Like **--rcheck**, except it will update the "last seen" timestamp if it matches.</dd>

<dt>[**!**] **--remove**</dt>

<dd>Check if the source address of the packet is currently in the list and if so that address will be removed from the list and the rule will return true. If the address is not found, false is returned.</dd>

<dt>[**!**] **--seconds** *seconds*</dt>

<dd>This option must be used in conjunction with one of **--rcheck** or **--update**. When used, this will narrow the match to only happen when the address is in the list and was seen within the last given number of seconds.</dd>

<dt>[**!**] **--hitcount** *hits*</dt>

<dd>This option must be used in conjunction with one of **--rcheck** or **--update**. When used, this will narrow the match to only happen when the address is in the list and packets had been received greater than or equal to the given value. This option may be used along with **--seconds** to create an even narrower match requiring a certain number of hits within a specific time frame.</dd>

<dt>**--rttl**

This option must be used in conjunction with one of **--rcheck** or **--update**. When used, this will narrow the match to only happen when the address is in the list and the TTL of the current packet matches that of the packet which hit the **--set** rule. This may be useful if you have problems with people faking their source address in order to DoS you via this module by disallowing others access to your site by sending bogus packets to you.

</dt>

<dt>Examples:</dt>

<dd># iptables -A FORWARD -m recent --name badguy --rcheck --seconds 60 -j DROP

# iptables -A FORWARD -p tcp -i eth0 --dport 139 -m recent --name badguy --set -j DROP

</dd>

<dt>Official website (<http://snowman.net/projects/ipt_recent/>) also has some examples of usage.

/proc/net/ipt_recent/* are the current lists of addresses and information about each entry of each list.

Each file in /proc/net/ipt_recent/ can be read from to see the current list or written two using the following commands to modify the list:

</dt>

<dt>echo xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT</dt>

<dd>to Add to the DEFAULT list</dd>

<dt>echo -xx.xx.xx.xx > /proc/net/ipt_recent/DEFAULT</dt>

<dd>to Remove from the DEFAULT list</dd>

<dt>echo clear > /proc/net/ipt_recent/DEFAULT</dt>

<dd>to empty the DEFAULT list.</dd>

<dt>The module itself accepts parameters, defaults shown:</dt>

<dt>**ip_list_tot=***100*</dt>

<dd>Number of addresses remembered per table</dd>

<dt>**ip_pkt_list_tot=***20*</dt>

<dd>Number of packets per address remembered</dd>

<dt>**ip_list_hash_size=***0*</dt>

<dd>Hash table size. 0 means to calculate it based on ip_list_tot, default: 512</dd>

<dt>**ip_list_perms=***0644*</dt>

<dd>Permissions for /proc/net/ipt_recent/* files</dd>

<dt>**debug=***0*</dt>

<dd>Set to 1 to get lots of debugging info</dd>

</dl>

### sctp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>**--source-port**,**--sport** [**!**] *port*[**:***port*]</dt>

<dt>**--destination-port**,**--dport** [**!**] *port*[**:***port*]</dt>

<dt>**--chunk-types** [**!**] **all**|**any**|**only** *chunktype*[**:***flags*] [...]</dt>

<dd>The flag letter in upper case indicates that the flag is to match if set, in the lower case indicates to match if unset.

Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK

chunk type available flags
DATA U B E u b e
ABORT T t
SHUTDOWN_COMPLETE T t

(lowercase means flag should be "off", uppercase means "on")

</dd>

<dt>Examples:

iptables -A INPUT -p sctp --dport 80 -j DROP

iptables -A INPUT -p sctp --chunk-types any DATA,INIT -j DROP

iptables -A INPUT -p sctp --chunk-types any DATA:Be -j ACCEPT

</dt>

</dl>

### set

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This modules macthes IP sets which can be defined by **[ipset](https://linux.die.net/man/8/ipset)**(8).</dt>

<dt>**--set** setname flag[,flag...]</dt>

<dd>where flags are **src** and/or **dst** and there can be no more than six of them. Hence the command
```
iptables -A FORWARD -m set --set test src,dst
```
will match packets, for which (depending on the type of the set) the source address or port number of the packet can be found in the specified set. If there is a binding belonging to the mached set element or there is a default binding for the given set, then the rule will match the packet only if additionally (depending on the type of the set) the destination address or port number of the packet can be found in the set according to the binding.</dd>

</dl>

### state

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module, when combined with connection tracking, allows access to the connection tracking state for this packet.</dt>

<dt>**--state** *state*</dt>

<dd>Where state is a comma separated list of the connection states to match. Possible states are **INVALID** meaning that the packet could not be identified for some reason which includes running out of memory and ICMP errors which don't correspond to any known connection, **ESTABLISHED** meaning that the packet is associated with a connection which has seen packets in both directions, **NEW** meaning that the packet has started a new connection, or otherwise associated with a connection which has not seen packets in both directions, and **RELATED** meaning that the packet is starting a new connection, but is associated with an existing connection, such as an FTP data transfer, or an ICMP error.</dd>

</dl>

### string

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This modules matches a given string by using some pattern matching strategy. It requires a linux kernel >= 2.6.14.</dt>

<dt>**--algo** *bm|kmp*</dt>

<dd>Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)</dd>

<dt>**--from** *offset*</dt>

<dd>Set the offset from which it starts looking for any matching. If not passed, default is 0.</dd>

<dt>**--to** *offset*</dt>

<dd>Set the offset from which it starts looking for any matching. If not passed, default is the packet size.</dd>

<dt>**--string** *pattern*</dt>

<dd>Matches the given pattern. **--hex-string** *pattern* Matches the given pattern in hex notation.</dd>

</dl>

### tcp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>These extensions are loaded if '--protocol tcp' is specified. It provides the following options:</dt>

<dt>**--source-port** [!] *port*[:*port*]</dt>

<dd>Source port or port range specification. This can either be a service name or a port number. An inclusive range can also be specified, using the format *port*:*port*. If the first port is omitted, "0" is assumed; if the last is omitted, "65535" is assumed. If the second port greater then the first they will be swapped. The flag **--sport** is a convenient alias for this option.</dd>

<dt>**--destination-port** [!] *port*[:*port*]</dt>

<dd>Destination port or port range specification. The flag **--dport** is a convenient alias for this option.</dd>

<dt>**--tcp-flags** [!] *mask comp*</dt>

<dd>Match when the TCP flags are as specified. The first argument is the flags which we should examine, written as a comma-separated list, and the second argument is a comma-separated list of flags which must be set. Flags are: **SYN ACK FIN RST URG PSH ALL NONE**. Hence the command
```
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
```
will only match packets with the SYN flag set, and the ACK, FIN and RST flags unset.</dd>

<dt>**[!] --syn**</dt>

<dd>Only match TCP packets with the SYN bit set and the ACK,RST and FIN bits cleared. Such packets are used to request TCP connection initiation; for example, blocking such packets coming in an interface will prevent incoming TCP connections, but outgoing TCP connections will be unaffected. It is equivalent to **--tcp-flags SYN,RST,ACK,FIN SYN**. If the "!" flag precedes the "--syn", the sense of the option is inverted.</dd>

<dt>**--tcp-option** [!] *number*</dt>

<dd>Match if TCP option set.</dd>

<dt>**--mss** *value*[:*value*]</dt>

<dd>Match TCP SYN or SYN/ACK packets with the specified MSS value (or range), which control the maximum packet size for that connection.</dd>

</dl>

### tcpmss

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This matches the TCP MSS (maximum segment size) field of the TCP header. You can only use this on TCP SYN or SYN/ACK packets, since the MSS is only negotiated during the TCP handshake at connection startup time.</dt>

<dt>**[!]** *--mss value[:value]"*</dt>

<dd>Match a given TCP MSS value or range.</dd>

</dl>

### time

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This matches if the packet arrival time/date is within a given range. All options are facultative.</dt>

<dt>**--timestart** *value*</dt>

<dd>Match only if it is after 'value' (Inclusive, format: HH:MM ; default 00:00).</dd>

<dt>**--timestop** *value*</dt>

<dd>Match only if it is before 'value' (Inclusive, format: HH:MM ; default 23:59).</dd>

<dt>**--days** *listofdays*</dt>

<dd>Match only if today is one of the given days. (format: Mon,Tue,Wed,Thu,Fri,Sat,Sun ; default everyday)</dd>

<dt>**--datestart** *date*</dt>

<dd>Match only if it is after 'date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]] ; h,m,s start from 0 ; default to 1970)</dd>

<dt>**--datestop** *date*</dt>

<dd>Match only if it is before 'date' (Inclusive, format: YYYY[:MM[:DD[:hh[:mm[:ss]]]]] ; h,m,s start from 0 ; default to 2037)</dd>

</dl>

### tos

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the 8 bits of Type of Service field in the IP header (ie. including the precedence bits).</dt>

<dt>**--tos** *tos*</dt>

<dd>The argument is either a standard name, (use
iptables -m tos -h
to see the list), or a numeric value to match.</dd>

</dl>

### ttl

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module matches the time to live field in the IP header.</dt>

<dt>**--ttl-eq** *ttl*</dt>

<dd>Matches the given TTL value.</dd>

<dt>**--ttl-gt** *ttl*</dt>

<dd>Matches if TTL is greater than the given TTL value.</dd>

<dt>**--ttl-lt** *ttl*</dt>

<dd>Matches if TTL is less than the given TTL value.</dd>

</dl>

### u32

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>U32 allows you to extract quantities of up to 4 bytes from a packet, AND them with specified masks, shift them by specified amounts and test whether the results are in any of a set of specified ranges. The specification of what to extract is general enough to skip over headers with lengths stored in the packet, as in IP or TCP header lengths.

Details and examples are in the kernel module source.

</dt>

</dl>

### udp

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>These extensions are loaded if '--protocol udp' is specified. It provides the following options:</dt>

<dt>**--source-port** [!] *port*[:*port*]</dt>

<dd>Source port or port range specification. See the description of the **--source-port** option of the TCP extension for details.</dd>

<dt>**--destination-port** [!] *port*[:*port*]</dt>

<dd>Destination port or port range specification. See the description of the **--destination-port** option of the TCP extension for details.</dd>

</dl>

### unclean

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module takes no options, but attempts to match packets which seem malformed or unusual. This is regarded as experimental.</dt>

</dl>

## Target Extensions

iptables can use extended target modules: the following are included in the standard distribution.

### BALANCE

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This allows you to DNAT connections in a round-robin way over a given range of destination addresses.</dt>

<dt>**--to-destination** *ipaddr-ipaddr*</dt>

<dd>Address range to round-robin over.</dd>

</dl>

### CLASSIFY

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module allows you to set the skb->priority value (and thus classify the packet into a specific CBQ class).</dt>

<dt>**--set-class** *MAJOR:MINOR*</dt>

<dd>Set the major and minor class value.</dd>

</dl>

### CLUSTERIP

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module allows you to configure a simple cluster of nodes that share a certain IP and MAC address without an explicit load balancer in front of them. Connections are statically distributed between the nodes in this cluster.</dt>

<dt>**--new**

Create a new ClusterIP. You always have to set this on the first rule for a given ClusterIP.

</dt>

<dt>**--hashmode** *mode*</dt>

<dd>Specify the hashing mode. Has to be one of **sourceip, sourceip-sourceport, sourceip-sourceport-destport**</dd>

<dt>**--clustermac** *mac*</dt>

<dd>Specify the ClusterIP MAC address. Has to be a link-layer multicast address</dd>

<dt>**--total-nodes** *num*</dt>

<dd>Number of total nodes within this cluster.</dd>

<dt>**--local-node** *num*</dt>

<dd>Local node number within this cluster.</dd>

<dt>**--hash-init** *rnd*</dt>

<dd>Specify the random seed used for hash initialization.</dd>

</dl>

### CONNMARK

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This module sets the netfilter mark value associated with a connection</dt>

<dt>**--set-mark mark[/mask]**</dt>

<dd>Set connection mark. If a mask is specified then only those bits set in the mask is modified.</dd>

<dt>**--save-mark [--mask mask]**</dt>

<dd>Copy the netfilter packet mark value to the connection mark. If a mask is specified then only those bits are copied.</dd>

<dt>**--restore-mark [--mask mask]**</dt>

<dd>Copy the connection mark value to the packet. If a mask is specified then only those bits are copied. This is only valid in the **mangle** table.</dd>

</dl>

### DNAT

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target is only valid in the **nat** table, in the **PREROUTING** and **OUTPUT** chains, and user-defined chains which are only called from those chains. It specifies that the destination address of the packet should be modified (and all future packets in this connection will also be mangled), and rules should cease being examined. It takes one type of option:</dt>

<dt>**--to-destination** *ipaddr*[-*ipaddr*][:*port*-*port*]</dt>

<dd>which can specify a single new destination IP address, an inclusive range of IP addresses, and optionally, a port range (which is only valid if the rule also specifies **-p tcp** or **-p udp**). If no port range is specified, then the destination port will never be modified.</dd>

<dd>In Kernels up to 2.6.10 you can add several --to-destination options. For those kernels, if you specify more than one destination address, either via an address range or multiple --to-destination options, a simple round-robin (one after another in cycle) load balancing takes place between these addresses. Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges anymore.</dd>

</dl>

### DSCP

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target allows to alter the value of the DSCP bits within the TOS header of the IPv4 packet. As this manipulates a packet, it can only be used in the mangle table.</dt>

<dt>**--set-dscp** *value*</dt>

<dd>Set the DSCP field to a numerical value (can be decimal or hex)</dd>

<dt>**--set-dscp-class** *class*</dt>

<dd>Set the DSCP field to a DiffServ class.</dd>

</dl>

### ECN

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target allows to selectively work around known ECN blackholes. It can only be used in the mangle table.</dt>

<dt>**--ecn-tcp-remove**</dt>

<dd>Remove all ECN bits from the TCP header. Of course, it can only be used in conjunction with **-p tcp**.</dd>

</dl>

### IPMARK

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Allows you to mark a received packet basing on its IP address. This can replace many mangle/mark entries with only one, if you use firewall based classifier.

This target is to be used inside the mangle table, in the PREROUTING, POSTROUTING or FORWARD hooks.

</dt>

<dt>**--addr** *src/dst*</dt>

<dd>Use source or destination IP address.</dd>

<dt>**--and-mask** *mask*</dt>

<dd>Perform bitwise 'and' on the IP address and this mask.</dd>

<dt>**--or-mask** *mask*</dt>

<dd>Perform bitwise 'or' on the IP address and this mask.</dd>

<dt>The order of IP address bytes is reversed to meet "human order of bytes": 192.168.0.1 is 0xc0a80001\. At first the 'and' operation is performed, then 'or'.

Examples:

We create a queue for each user, the queue number is adequate to the IP address of the user, e.g.: all packets going to/from 192.168.5.2 are directed to 1:0502 queue, 192.168.5.12 -> 1:050c etc.

We have one classifier rule:

</dt>

<dd>tc filter add dev eth3 parent 1:0 protocol ip fw</dd>

<dt>Earlier we had many rules just like below:</dt>

<dd>iptables -t mangle -A POSTROUTING -o eth3 -d 192.168.5.2 -j MARK --set-mark 0x10502

iptables -t mangle -A POSTROUTING -o eth3 -d 192.168.5.3 -j MARK --set-mark 0x10503

</dd>

<dt>Using IPMARK target we can replace all the mangle/mark rules with only one:</dt>

<dd>iptables -t mangle -A POSTROUTING -o eth3 -j IPMARK --addr=dst --and-mask=0xffff --or-mask=0x10000</dd>

<dt>On the routers with hundreds of users there should be significant load decrease (e.g. twice).</dt>

</dl>

### IPV4OPTSSTRIP

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Strip all the IP options from a packet.

The target doesn't take any option, and therefore is extremly easy to use :

# iptables -t mangle -A PREROUTING -j IPV4OPTSSTRIP

</dt>

</dl>

### LOG

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Turn on kernel logging of matching packets. When this option is set for a rule, the Linux kernel will print some information on all matching packets (like most IP header fields) via the kernel log (where it can be read with *dmesg* or **[syslogd](https://linux.die.net/man/8/syslogd)**(8)). This is a "non-terminating target", i.e. rule traversal continues at the next rule. So if you want to LOG the packets you refuse, use two separate rules with the same matching criteria, first using target LOG then DROP (or REJECT).</dt>

<dt>**--log-level** *level*</dt>

<dd>Level of logging (numeric or see **[syslog.conf](https://linux.die.net/man/5/syslog.conf)**(5)).</dd>

<dt>**--log-prefix** *prefix*</dt>

<dd>Prefix log messages with the specified prefix; up to 29 letters long, and useful for distinguishing messages in the logs.</dd>

<dt>**--log-tcp-sequence**</dt>

<dd>Log TCP sequence numbers. This is a security risk if the log is readable by users.</dd>

<dt>**--log-tcp-options**</dt>

<dd>Log options from the TCP packet header.</dd>

<dt>**--log-ip-options**</dt>

<dd>Log options from the IP packet header.</dd>

<dt>**--log-uid**</dt>

<dd>Log the userid of the process which generated the packet.</dd>

</dl>

### MARK

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This is used to set the netfilter mark value associated with the packet. It is only valid in the **mangle** table. It can for example be used in conjunction with iproute2.</dt>

<dt>**--set-mark** *mark*</dt>

</dl>

### MASQUERADE

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target is only valid in the **nat** table, in the **POSTROUTING** chain. It should only be used with dynamically assigned IP (dialup) connections: if you have a static IP address, you should use the SNAT target. Masquerading is equivalent to specifying a mapping to the IP address of the interface the packet is going out, but also has the effect that connections are *forgotten* when the interface goes down. This is the correct behavior when the next dialup is unlikely to have the same interface address (and hence any established connections are lost anyway). It takes one option:</dt>

<dt>**--to-ports** *port*[-*port*]</dt>

<dd>This specifies a range of source ports to use, overriding the default **SNAT** source port-selection heuristics (see above). This is only valid if the rule also specifies **-p tcp** or **-p udp**.</dd>

</dl>

### MIRROR

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This is an experimental demonstration target which inverts the source and destination fields in the IP header and retransmits the packet. It is only valid in the **INPUT**, **FORWARD** and **PREROUTING** chains, and user-defined chains which are only called from those chains. Note that the outgoing packets are **NOT** seen by any packet filtering chains, connection tracking or NAT, to avoid loops and other problems.</dt>

</dl>

### NETMAP

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target allows you to statically map a whole network of addresses onto another network of addresses. It can only be used from rules in the **nat** table.</dt>

<dt>**--to** *address[/mask]*</dt>

<dd>Network address to map to. The resulting address will be constructed in the following way: All 'one' bits in the mask are filled in from the new 'address'. All bits that are zero in the mask are filled in from the original address.</dd>

</dl>

### NFQUEUE

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target is an extension of the QUEUE target. As opposed to QUEUE, it allows you to put a packet into any specific queue, identified by its 16-bit queue number.</dt>

<dt>**--queue-num** *value*</dt>

<dd>This specifies the QUEUE number to use. Valud queue numbers are 0 to 65535\. The default value is 0.</dd>

<dt>It can only be used with Kernel versions 2.6.14 or later, since it requires</dt>

<dd>the **nfnetlink_queue** kernel support.</dd>

</dl>

### NOTRACK

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target disables connection tracking for all packets matching that rule.</dt>

<dt>It can only be used in the</dt>

<dd>**raw** table.</dd>

</dl>

### REDIRECT

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target is only valid in the **nat** table, in the **PREROUTING** and **OUTPUT** chains, and user-defined chains which are only called from those chains. It redirects the packet to the machine itself by changing the destination IP to the primary address of the incoming interface (locally-generated packets are mapped to the 127.0.0.1 address). It takes one option:</dt>

<dt>**--to-ports** *port*[-*port*]</dt>

<dd>This specifies a destination port or range of ports to use: without this, the destination port is never altered. This is only valid if the rule also specifies **-p tcp** or **-p udp**.</dd>

</dl>

### REJECT

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This is used to send back an error packet in response to the matched packet: otherwise it is equivalent to **DROP** so it is a terminating TARGET, ending rule traversal. This target is only valid in the **INPUT**, **FORWARD** and **OUTPUT** chains, and user-defined chains which are only called from those chains. The following option controls the nature of the error packet returned:</dt>

<dt>**--reject-with** *type*</dt>

<dd>The type given can be
```
 **icmp-net-unreachable
 icmp-host-unreachable
 icmp-port-unreachable
 icmp-proto-unreachable
 icmp-net-prohibited
 icmp-host-prohibited or
 icmp-admin-prohibited (*)**
```
which return the appropriate ICMP error message (**port-unreachable** is the default). The option **tcp-reset** can be used on rules which only match the TCP protocol: this causes a TCP RST packet to be sent back. This is mainly useful for blocking *ident* (113/tcp) probes which frequently occur when sending mail to broken mail hosts (which won't accept your mail otherwise).</dd>

<dt>(*) Using icmp-admin-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT</dt>

</dl>

### SAME

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Similar to SNAT/DNAT depending on chain: it takes a range of addresses ('--to 1.2.3.4-1.2.3.7') and gives a client the same source-/destination-address for each connection.</dt>

<dt>**--to** *<ipaddr>-<ipaddr>*</dt>

<dd>Addresses to map source to. May be specified more than once for multiple ranges.</dd>

<dt>**--nodst**</dt>

<dd>Don't use the destination-ip in the calculations when selecting the new source-ip</dd>

</dl>

### SET

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This modules adds and/or deletes entries from IP sets which can be defined by **[ipset](https://linux.die.net/man/8/ipset)**(8).</dt>

<dt>**--add-set** setname flag[,flag...]</dt>

<dd>add the address(es)/**port**(s) of the packet to the sets</dd>

<dt>**--del-set** setname flag[,flag...]</dt>

<dd>delete the address(es)/**port**(s) of the packet from the sets, where flags are **src** and/or **dst** and there can be no more than six of them.</dd>

<dt>The bindings to follow must previously be defined in order to use</dt>

<dd>multilevel adding/deleting by the SET target.</dd>

</dl>

### SNAT

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target is only valid in the **nat** table, in the **POSTROUTING** chain. It specifies that the source address of the packet should be modified (and all future packets in this connection will also be mangled), and rules should cease being examined. It takes one type of option:</dt>

<dt>**--to-source** *ipaddr*[-*ipaddr*][:*port*-*port*]</dt>

<dd>which can specify a single new source IP address, an inclusive range of IP addresses, and optionally, a port range (which is only valid if the rule also specifies **-p tcp** or **-p udp**). If no port range is specified, then source ports below 512 will be mapped to other ports below 512: those between 512 and 1023 inclusive will be mapped to ports below 1024, and other ports will be mapped to 1024 or above. Where possible, no port alteration will occur.</dd>

<dd>In Kernels up to 2.6.10, you can add several --to-source options. For those kernels, if you specify more than one source address, either via an address range or multiple --to-source options, a simple round-robin (one after another in cycle) takes place between these addresses. Later Kernels (>= 2.6.11-rc1) don't have the ability to NAT to multiple ranges anymore.</dd>

</dl>

### TARPIT

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Captures and holds incoming TCP connections using no local per-connection resources. Connections are accepted, but immediately switched to the persist state (0 byte window), in which the remote side stops sending data and asks to continue every 60-240 seconds. Attempts to close the connection are ignored, forcing the remote side to time out the connection in 12-24 minutes.

This offers similar functionality to LaBrea <<http://www.hackbusters.net/LaBrea/>> but doesn't require dedicated hardware or IPs. Any TCP port that you would normally DROP or REJECT can instead become a tarpit.

To tarpit connections to TCP port 80 destined for the current machine:

</dt>

<dd>iptables -A INPUT -p tcp -m tcp --dport 80 -j TARPIT</dd>

<dt>To significantly slow down Code Red/Nimda-style scans of unused address space, forward unused ip addresses to a Linux box not acting as a router (e.g. "ip route 10.0.0.0 255.0.0.0 ip.of.linux.box" on a Cisco), enable IP forwarding on the Linux box, and add:</dt>

<dd>iptables -A FORWARD -p tcp -j TARPIT

iptables -A FORWARD -j DROP

</dd>

<dt>NOTE:

If you use the conntrack module while you are using TARPIT, you should also use the NOTRACK target, or the kernel will unnecessarily allocate resources for each TARPITted connection. To TARPIT incoming connections to the standard IRC port while using conntrack, you could:

</dt>

<dd>iptables -t raw -A PREROUTING -p tcp --dport 6667 -j NOTRACK

iptables -A INPUT -p tcp --dport 6667 -j TARPIT

</dd>

</dl>

### TCPMSS

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target allows to alter the MSS value of TCP SYN packets, to control the maximum size for that connection (usually limiting it to your outgoing interface's MTU minus 40). Of course, it can only be used in conjunction with **-p tcp**. It is only valid in the **mangle** table.
This target is used to overcome criminally braindead ISPs or servers which block ICMP Fragmentation Needed packets. The symptoms of this problem are that everything works fine from your Linux firewall/router, but machines behind it can never exchange large packets:</dt>

<dt>1)

Web browsers connect, then hang with no data received.

2)

Small mail works fine, but large emails hang.

3)

ssh works fine, but scp hangs after initial handshaking.

</dt>

<dt>Workaround: activate this option and add a rule to your firewall configuration like:
```
iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN\
            -j TCPMSS --clamp-mss-to-pmtu
```
</dt>

<dt>**--set-mss** *value*</dt>

<dd>Explicitly set MSS option to specified value.</dd>

<dt>**--clamp-mss-to-pmtu**</dt>

<dd>Automatically clamp MSS value to (path_MTU - 40).</dd>

<dt>These options are mutually exclusive.</dt>

</dl>

### TOS

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This is used to set the 8-bit Type of Service field in the IP header. It is only valid in the **mangle** table.</dt>

<dt>**--set-tos** *tos*</dt>

<dd>You can use a numeric TOS values, or use
```
iptables -j TOS -h
```
to see the list of valid TOS names.</dd>

</dl>

### TRACE

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target has no options. It just turns on **packet tracing** for all packets that match this rule.</dt>

</dl>

### TTL

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This is used to modify the IPv4 TTL header field. The TTL field determines how many hops (routers) a packet can traverse until it's time to live is exceeded.</dt>

<dt>Setting or incrementing the TTL field can potentially be very dangerous,</dt>

<dd>so it should be avoided at any cost.</dd>

<dt>**Don't ever set or increment the value on packets that leave your local network!**</dt>

<dd>**mangle** table.</dd>

<dt>**--ttl-set** *value*</dt>

<dd>Set the TTL value to 'value'.</dd>

<dt>**--ttl-dec** *value*</dt>

<dd>Decrement the TTL value 'value' times.</dd>

<dt>**--ttl-inc** *value*</dt>

<dd>Increment the TTL value 'value' times.</dd>

</dl>

### ULOG

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>This target provides userspace logging of matching packets. When this target is set for a rule, the Linux kernel will multicast this packet through a *netlink* socket. One or more userspace processes may then subscribe to various multicast groups and receive the packets. Like LOG, this is a "non-terminating target", i.e. rule traversal continues at the next rule.</dt>

<dt>**--ulog-nlgroup** *nlgroup*</dt>

<dd>This specifies the netlink group (1-32) to which the packet is sent. Default value is 1.</dd>

<dt>**--ulog-prefix** *prefix*</dt>

<dd>Prefix log messages with the specified prefix; up to 32 characters long, and useful for distinguishing messages in the logs.</dd>

<dt>**--ulog-cprange** *size*</dt>

<dd>Number of bytes to be copied to userspace. A value of 0 always copies the entire packet, regardless of its size. Default is 0.</dd>

<dt>**--ulog-qthreshold** *size*</dt>

<dd>Number of packet to queue inside kernel. Setting this value to, e.g. 10 accumulates ten packets inside the kernel and transmits them as one netlink multipart message to userspace. Default is 1 (for backwards compatibility).</dd>

</dl>

### XOR

<dl compact="" style="color: rgb(68, 68, 68); font-family: verdana, helvetica, arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">

<dt>Encrypt TCP and UDP traffic using a simple XOR encryption</dt>

<dt>**--key** *string*</dt>

<dd>Set key to "string"</dd>

<dt>**--block-size**</dt>

<dd>Set block size</dd>

</dl>

## Diagnostics

Various error messages are printed to standard error. The exit code is 0 for correct functioning. Errors which appear to be caused by invalid or abused command line parameters cause an exit code of 2, and other errors cause an exit code of 1.

## Bugs

Bugs? What's this? ;-) Well, you might want to have a look at <http://bugzilla.netfilter.org/>

## Compatibility With Ipchains

This **iptables** is very similar to ipchains by Rusty Russell. The main difference is that the chains **INPUT** and **OUTPUT** are only traversed for packets coming into the local host and originating from the local host respectively. Hence every packet only passes through one of the three chains (except loopback traffic, which involves both INPUT and OUTPUT chains); previously a forwarded packet would pass through all three.

The other main difference is that **-i** refers to the input interface; **-o** refers to the output interface, and both are available for packets entering the **FORWARD** chain.

**iptables** is a pure packet filter when using the default 'filter' table, with optional extension modules. This should simplify much of the previous confusion over the combination of IP masquerading and packet filtering seen previously. So the following options are handled differently:

```
-j MASQ
-M -S
-M -L
```
There are several other changes in iptables.

## See Also

**[iptables-save](https://linux.die.net/man/8/iptables-save)**(8), **[iptables-restore](https://linux.die.net/man/8/iptables-restore)**(8), **[ip6tables](https://linux.die.net/man/8/ip6tables)**(8), **ip6tables-save**(8), **ip6tables-restore**(8), **[libipq](https://linux.die.net/man/3/libipq)**(3).

The packet-filtering-HOWTO details iptables usage for packet filtering, the NAT-HOWTO details NAT, the netfilter-extensions-HOWTO details the extensions that are not in the standard distribution, and the netfilter-hacking-HOWTO details the netfilter internals.
See **<http://www.netfilter.org/>**.

## Authors

Rusty Russell originally wrote iptables, in early consultation with Michael Neuling.

Marc Boucher made Rusty abandon ipnatctl by lobbying for a generic packet selection framework in iptables, then wrote the mangle table, the owner match, the mark stuff, and ran around doing cool stuff everywhere.

James Morris wrote the TOS target, and tos match.

Jozsef Kadlecsik wrote the REJECT target.

Harald Welte wrote the ULOG and NFQUEUE target, the new libiptc, as well as the TTL, DSCP, ECN matches and targets.

The Netfilter Core Team is: Marc Boucher, Martin Josefsson, Jozsef Kadlecsik, Patrick McHardy, James Morris, Harald Welte and Rusty Russell.

Man page originally written by Herve Eychenne <<rv@wallfire.org>>.

[//begin]: # "Autogenerated link references for markdown compatibility"
[理解iptables]: ../../../zh-cn/docs/cheetsheets/%E7%90%86%E8%A7%A3iptables "理解iptables"
[//end]: # "Autogenerated link references"