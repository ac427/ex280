# Network Policies

- podSelector

# Lab1: allow communication from  pod to pod using PodSelector

#### create new deployment bnginx and label app=server
```
$oc new-project nwplab
$oc new-app --name server --image bitnami/nginx
$oc get pods --show-labels 
NAME                      READY   STATUS    RESTARTS   AGE   LABELS
server-674bc9869f-hsgnj   1/1     Running   0          98s   deployment=server,pod-template-hash=674bc9869f
$oc label pod server-674bc9869f-hsgnj app=server
pod/server-674bc9869f-hsgnj labeled
```

#### apply podSelctor Network Policy

```
$cat nwp.yaml 
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-policy
spec:
  podSelector: 
    matchLabels:
      app: server
  ingress:
  - from:
    - podSelector: 
        matchLabels:
          allow: "true"
$oc apply -f nwp.yaml 
networkpolicy.networking.k8s.io/allow-policy created
```

#### deploy a pod and test the connection to bgninx service

```
$cat sleepy-pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox
spec:
  containers:
  - name: busybox
    image: busybox
    command:
    - sleep
    - "infinity"
$oc apply -f sleepy-pod.yaml 
pod/busybox created
$oc get pods --show-labels 
NAME                      READY   STATUS    RESTARTS   AGE   LABELS
busybox                   1/1     Running   0          5s    <none>
server-674bc9869f-hsgnj   1/1     Running   0          10m   app=server,deployment=server,pod-template-hash=674bc9869f
$oc get svc
NAME     TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)             AGE
server   ClusterIP   10.217.5.57   <none>        8080/TCP,8443/TCP   11m
$oc rsh busybox
/ # wget --spider 10.217.5.57:8080 --timeout 1
Connecting to 10.217.5.57:8080 (10.217.5.57:8080)
wget: download timed out
```

#### apply label allow=true to busybox and test connection

```
$oc label pod busybox allow=true
pod/busybox labeled
$oc get pods --show-labels 
NAME                      READY   STATUS    RESTARTS   AGE    LABELS
busybox                   1/1     Running   0          4m3s   allow=true
server-674bc9869f-hsgnj   1/1     Running   0          14m    app=server,deployment=server,pod-template-hash=674bc9869f
$oc rsh busybox
/ # wget --spider 10.217.5.57:8080 --timeout 1
Connecting to 10.217.5.57:8080 (10.217.5.57:8080)
remote file exists
```
