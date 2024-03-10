---
title: calico探索
---

# calico 探索

## 故障

### 修改配置

```bash
[root@k8s-03:~/.kube 20:41 $]k get ippools.crd.projectcalico.org -o yaml
apiVersion: v1
items:
- apiVersion: crd.projectcalico.org/v1
  kind: IPPool
  metadata:
    annotations:
      kubectl.kubernetes.io/last-applied-configuration: |
        {"apiVersion":"crd.projectcalico.org/v1","kind":"IPPool","metadata":{"annotations":{},"generation":1,"name":"default-ipv4-ippool"},"spec":{"allowedUses":["Workload","Tunnel"],"blockSize":26,"cidr":"192.168.0.0/16","ipipMode":"Never","natOutgoing":true,"nodeSelector":"all()","vxlanMode":"Always"}}
      projectcalico.org/metadata: '{"uid":"0891de51-013e-4a44-9cb6-0c142f480567","creationTimestamp":"2023-05-26T07:36:30Z"}'
    creationTimestamp: "2023-05-26T07:36:30Z"
    generation: 3
    name: default-ipv4-ippool
    resourceVersion: "37479"
    uid: de7868c1-ad93-4441-aa22-9198d07822f5
  spec:
    allowedUses:
    - Workload
    - Tunnel
    blockSize: 26
    cidr: 192.168.0.0/16
    ipipMode: Never
    natOutgoing: true
    nodeSelector: all()
    vxlanMode: Always
kind: List
metadata:
  resourceVersion: ""

[root@k8s-03:~/.kube 20:41 $]k edit ippools.crd.projectcalico.org default-ipv4-ippool
```

参考文档:

- https://docs.tigera.io/calico/latest/networking/configuring/vxlan-ipip
-
