# Network Policy
 - podSelector && namespaceSelector

# Lab: 
  - create ns target and source
  - deploy nginx on target ns and add label host=server to the nginx pod
  - label source namespace to deployment=clients
  - create two pods client1 and client2 on source ns
  - write network policy to allow only client2 from ns source to communicate 

#### create projects

```
$oc new-project source
$oc new-project target
```

#### create deployment nginx on target project

```
$oc project target
$oc new-app --name bnginx --image bitnami/nginx
$oc get pods --show-labels
NAME                     READY   STATUS    RESTARTS   AGE   LABELS
bnginx-55f4968b5-rvmlb   1/1     Running   0          9s    deployment=bnginx,pod-template-hash=55f4968b5
$oc label pod bnginx-55f4968b5-rvmlb host=server
pod/bnginx-55f4968b5-rvmlb labeled
$oc get svc
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
bnginx   ClusterIP   10.217.5.183   <none>        8080/TCP,8443/TCP   9s
```

#### label source project

```
$oc project source
$oc label namespace source deployment=clients
namespace/source labeled
```

#### create two pods in project source

```
$oc project source
$cat clients.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: client1
spec:
  containers:
  - name: client1
    image: busybox
    command:
    - sleep
    - "infinity"
---
apiVersion: v1
kind: Pod
metadata:
  name: client2
spec:
  containers:
  - name: client2
    image: busybox
    command:
    - sleep
    - "infinity"
$oc apply -f clients.yaml 
pod/client1 created
pod/client2 created
```

```
$oc get pods --show-labels 
NAME      READY   STATUS    RESTARTS   AGE    LABELS
client1   1/1     Running   0          114s   <none>
client2   1/1     Running   0          114s   <none>
$oc label pod client2 allow="true"
pod/client2 labeled
```

#### apply network policy

```
$cat nwp1.yaml 
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: select
  namespace: target
spec:
  podSelector:
    matchLabels:
      host: "server"
  ingress:
    - from:
      - namespaceSelector:
          matchLabels:
            deployment: clients
        podSelector:
          matchLabels:
            access: "allow"
      ports:
      - port: 8080
        protocol: TCP
$oc apply -f nwp1.yaml 
networkpolicy.networking.k8s.io/select created
```

#### Test connections

```
$oc rsh client1
/ # wget --spider 10.217.5.183:8080 --timeout 1
Connecting to 10.217.5.183:8080 (10.217.5.183:8080)
wget: download timed out
/ # 
command terminated with exit code 1
$oc rsh client2
/ # wget --spider 10.217.5.183:8080 --timeout 1
Connecting to 10.217.5.183:8080 (10.217.5.183:8080)
wget: download timed out
```

# Hmm.. both are timing out? Do you know why? Solution is in 04d-Configure_networking_components.md
