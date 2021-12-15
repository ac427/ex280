```
$oc new-project q2
Now using project "q2" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

$oc create configmap secret --from-literal PASSWORD=topsecret
configmap/secret created
$oc run busybox --image=busybox --dry-run=client --command sleep infinity -o yaml > busybox.yaml
```

from the configmap docs look how to export env and update busybox.yaml ( line 16 to 18 )

```
$oc apply -f busybox.yaml 
pod/busybox created
$oc get pods
NAME      READY   STATUS    RESTARTS   AGE
busybox   1/1     Running   0          5s
$oc rsh busybox
/ # env | grep -i password
PASSWORD=topsecret
```
