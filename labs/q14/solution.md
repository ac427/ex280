# Soluton 1

```
$oc new-project net-1

$oc new-project net-2

$oc new-app --name bnginx --image=bitnami/nginx

$oc apply -f net-policy-1.yaml 
networkpolicy.networking.k8s.io/allow-net1 created

$oc label namespaces net-1 ns=net1

$oc get svc
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
bnginx   ClusterIP   10.217.4.126   <none>        8080/TCP,8443/TCP   108s

$oc run busybox -it --image busybox --restart=Never  --namespace=net-1
If you don't see a command prompt, try pressing enter.
/ # wget 10.217.4.126:8080
Connecting to 10.217.4.126:8080 (10.217.4.126:8080)
saving to 'index.html'
index.html           100% |***************************************************************************************************|   615  0:00:00 ETA
'index.html' saved
/ # 

```

Now lets remove the label ns=net1 and run wget again and see if it works

```
$oc delete pod busybox -n net-1
pod "busybox" deleted

$oc label namespaces net-1 ns-
namespace/net-1 labeled

          Active   6m1s    kubernetes.io/metadata.name=net-1
$oc run busybox -it --image busybox --restart=Never  --namespace=net-1
If you don't see a command prompt, try pressing enter.

/ # wget --spider -T 5 10.217.4.126:8080
Connecting to 10.217.4.126:8080 (10.217.4.126:8080)
wget: download timed out

```



# Solution 2

```
oc apply -f net-policy-2.yaml -n net-2 

$oc label namespaces net-1 ns=client --overwrite
namespace/net-1 labeled


$oc delete pod busybox -n net-1
pod "busybox" deleted
$
$oc run busybox -it --image busybox --restart=Never  --namespace=net-1
If you don't see a command prompt, try pressing enter.
/ # wget --spider -T 5 10.217.4.126:8080
Connecting to 10.217.4.126:8080 (10.217.4.126:8080)
wget: download timed out
/ # exit 

$oc delete pod busybox -n net-1
pod "busybox" deleted
$oc run busybox -it --image busybox --restart=Never  --namespace=net-1 --labels="app=client"
If you don't see a command prompt, try pressing enter.
/ # wget --spider -T 5 10.217.4.126:8080
Connecting to 10.217.4.126:8080 (10.217.4.126:8080)
remote file exists
/ # 

```
