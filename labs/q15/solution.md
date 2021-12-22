# Solution 1

```
$oc adm new-project node-selector --node-selector='project=dev'
Created project node-selector

$oc new-app --name bnginx --image=bitnami/nginx
--> Found container image a744755 (29 minutes old) from Docker Hub for "bitnami/nginx"

    * An image stream tag will be created as "bnginx:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "bnginx" created
    deployment.apps "bnginx" created
    service "bnginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/bnginx' 
    Run 'oc status' to view your app.
$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-559bd769bf-w8qm6   0/1     Pending   0          35s
$oc describe pod bnginx-559bd769bf-w8qm6 
Name:           bnginx-559bd769bf-w8qm6
Namespace:      node-selector
Priority:       0
Node:           <none>
Labels:         deployment=bnginx
                pod-template-hash=559bd769bf
Annotations:    openshift.io/generated-by: OpenShiftNewApp
                openshift.io/scc: restricted
Status:         Pending
IP:             
IPs:            <none>
Controlled By:  ReplicaSet/bnginx-559bd769bf
Containers:
  bnginx:
    Image:        bitnami/nginx@sha256:69401ff0079a5e8a36cf551c465a62a8851345a24e83b29ca43e30b0e8b590d4
    Ports:        8080/TCP, 8443/TCP
    Host Ports:   0/TCP, 0/TCP
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-tmf5n (ro)
Conditions:
  Type           Status
  PodScheduled   False 
Volumes:
  kube-api-access-tmf5n:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
    ConfigMapName:           openshift-service-ca.crt
    ConfigMapOptional:       <nil>
QoS Class:                   BestEffort
Node-Selectors:              project=dev
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  40s   default-scheduler  0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector.
$
```


# Solution 2

```
$oc get nodes --show-labels 
NAME                 STATUS   ROLES           AGE   VERSION           LABELS
crc-x4qnm-master-0   Ready    master,worker   25d   v1.22.2+5e38c72   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=crc-x4qnm-master-0,kubernetes.io/os=linux,node-role.kubernetes.io/master=,node-role.kubernetes.io/worker=,node.openshift.io/os_id=rhcos
$oc label nodes crc-x4qnm-master-0 project=dev
node/crc-x4qnm-master-0 labeled
$oc get pods
NAME                      READY   STATUS              RESTARTS   AGE
bnginx-559bd769bf-w8qm6   0/1     ContainerCreating   0          87s
$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-559bd769bf-w8qm6   1/1     Running   0          92s

```


# Solution 3

Tip: create project with node-selector 

`$oc adm new-project qux --node-selector="foo=bar"` . run `oc get project foo -o yaml`.

```
oc new-project foo
$oc annotate namespace foo openshift.io/node-selector="project=dev"
namespace/foo annotated
```


# Solution 4

```
$oc project node-selector
Now using project "node-selector" on server "https://api.crc.testing:6443".
$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-559bd769bf-w8qm6   1/1     Running   0          30m
$oc scale --replicas=2 deployment/bnginx
deployment.apps/bnginx scaled
$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-559bd769bf-pzm8k   1/1     Running   0          3s
bnginx-559bd769bf-w8qm6   1/1     Running   0          31m
```
