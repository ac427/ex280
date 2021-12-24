# Solution 1

```
oc get nodes
NAME      STATUS   ROLES                  AGE     VERSION
master    Ready    control-plane,master   5h23m   v1.23.1
worker1   Ready    <none>                 4h36m   v1.23.1
worker2   Ready    <none>                 4h36m   v1.23.1
worker3   Ready    <none>                 4h36m   v1.23.1
```

```
oc apply -f q18-pod-anti.yaml 
deployment.apps/pod-anti-affinity created
oc get pods -o wide
NAME                                 READY   STATUS    RESTARTS   AGE   IP                NODE      NOMINATED NODE   READINESS GATES
pod-anti-affinity-5bf8fbb9fc-4cvpj   1/1     Running   0          3s    192.168.235.147   worker1   <none>           <none>
pod-anti-affinity-5bf8fbb9fc-64p4c   0/1     Pending   0          3s    <none>            <none>    <none>           <none>
pod-anti-affinity-5bf8fbb9fc-8l2fn   1/1     Running   0          3s    192.168.182.18    worker3   <none>           <none>
pod-anti-affinity-5bf8fbb9fc-lkqx2   1/1     Running   0          3s    192.168.189.81    worker2   <none>           <none>
oc describe pod pod-anti-affinity-5bf8fbb9fc-64p4c | tail -4
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  15s   default-scheduler  0/4 nodes are available: 1 node(s) had taint {node-role.kubernetes.io/master: }, that the pod didn't tolerate, 3 node(s) didn't match pod anti-affinity rules.
```

```
oc apply -f q18-pod-anti.yaml 
deployment.apps/pod-anti-affinity created
oc get pods -o wide
NAME                                 READY   STATUS    RESTARTS   AGE   IP                NODE      NOMINATED NODE   READINESS GATES
pod-anti-affinity-5bf8fbb9fc-4cvpj   1/1     Running   0          3s    192.168.235.147   worker1   <none>           <none>
pod-anti-affinity-5bf8fbb9fc-64p4c   0/1     Pending   0          3s    <none>            <none>    <none>           <none>
pod-anti-affinity-5bf8fbb9fc-8l2fn   1/1     Running   0          3s    192.168.182.18    worker3   <none>           <none>
pod-anti-affinity-5bf8fbb9fc-lkqx2   1/1     Running   0          3s    192.168.189.81    worker2   <none>           <none>
oc describe pod pod-anti-affinity-5bf8fbb9fc-64p4c | tail -4
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  15s   default-scheduler  0/4 nodes are available: 1 node(s) had taint {node-role.kubernetes.io/master: }, that the pod didn't tolerate, 3 node(s) didn't match pod anti-affinity rules.
```


# Solution 2

```
$oc label nodes worker1 type=dev
node/worker1 labeled
$oc label nodes worker3 type=dev
node/worker3 labeled
$oc create deployment  bnginx --image bitnami/nginx --replicas=4 --dry-run=client -o yaml > node-affinity.yaml
$vi node-affinity.yaml 
$oc apply -f node-affinity.yaml 
deployment.apps/bnginx created
$oc get pods -o wide
NAME                      READY   STATUS              RESTARTS   AGE   IP                NODE      NOMINATED NODE   READINESS GATES
bnginx-6847b9c5cc-4jp6l   1/1     Running             0          5s    192.168.182.21    worker3   <none>           <none>
bnginx-6847b9c5cc-j986t   0/1     ContainerCreating   0          5s    <none>            worker1   <none>           <none>
bnginx-6847b9c5cc-mnp2r   1/1     Running             0          5s    192.168.182.20    worker3   <none>           <none>
bnginx-6847b9c5cc-rdfs7   1/1     Running             0          5s    192.168.235.149   worker1   <none>           <none>
```
