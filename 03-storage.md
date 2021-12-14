# Storage

two pods sharing an empty dir. the data in the dir will be available until the end of the pod life.

In below deployment we are running second container sleep2 only for 30 sec. You can see the data still available after pod getting killed.
If both the pods die then the data gets destroyed.

```
cat volume-empty-dir.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: empty-dir
spec:
  containers:
    - name: sleep1
      command:
        - sleep
        - infinity
      image: busybox
      volumeMounts:
        - name: test
          mountPath: /data

    - name: sleep2
      command:
        - sleep
        - '30'
      image: busybox
      volumeMounts:
        - name: test
          mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
    - name: test
      emptyDir: {}
$oc apply -f volume-empty-dir.yaml 
pod/empty-dir created
$oc get pods
NAME        READY   STATUS              RESTARTS   AGE
empty-dir   0/2     ContainerCreating   0          4s
$oc exec -it empty-dir -c sleep1 -- sh
/ # echo foo > /data/qux
/ # 
$oc exec -it empty-dir -c sleep2 -- sh
/ # cat command terminated with exit code 137
$oc exec -it empty-dir -c sleep2 -- sh
/ # cat /data/qux
foo
/ # echo qux >> /data/qux
/ # command terminated with exit code 137
$oc exec -it empty-dir -c sleep1 -- sh
/ # cat /data/qux
foo
qux
```

# Persistant Volumes

```
$oc apply -f pv.yaml 
persistentvolume/pv-ex280 created

$cat pv.yaml 
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-ex280
  labels:
    type: volume
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"

$oc get pv | egrep 'ex280|NAME'
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                                                 STORAGECLASS   REASON   AGE
pv-ex280   2Gi        RWO            Retain           Available                                                                                 100s

$oc apply -f pvc.yaml 
persistentvolumeclaim/pv-claim created
```

Status changed to Bound

```
$oc get pv | egrep "NAME|ex280"
NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM                                                 STORAGECLASS   REASON   AGE
pv-ex280   2Gi        RWO            Retain           Bound       storage/pv-claim                                                              7m50s
$oc get pvc
NAME       STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pv-claim   Bound    pv-ex280   2Gi        RWO                           89s

```

```
$oc apply -f pv-pod.yaml 
pod/pv-pod created

$oc rsh pv-pod
# 
# cd /usr/share/nginx/html
# echo hello > hello.html
# exit
$oc get pods
NAME     READY   STATUS    RESTARTS   AGE
pv-pod   1/1     Running   0          62s
$oc delete pod pv-pod
pod "pv-pod" deleted
$oc apply -f pv-pod.yaml 
pod/pv-pod created
$oc rsh pv-pod
# ls /usr/share/nginx/html
hello.html
```

Data is actually stored on hostpath (crc vm) /mnt/data

```
$ssh -i ~/.crc/machines/crc/id_ecdsa core@$(crc ip)
Red Hat Enterprise Linux CoreOS 49.84.202110220538-0
  Part of OpenShift 4.9, RHCOS is a Kubernetes native operating system
  managed by the Machine Config Operator (`clusteroperator/machine-config`).

WARNING: Direct SSH access to machines is not recommended; instead,
make configuration changes via `machineconfig` objects:
  https://docs.openshift.com/container-platform/4.9/architecture/architecture-rhcos.html

---
Last login: Tue Dec 14 02:17:54 2021 from 192.168.130.1
[core@crc-ktfxm-master-0 ~]$ cat /mnt/data/hello.html 
hello
[core@crc-ktfxm-master-0 ~]$ echo from crc >> /mnt/data/hello.html 
[core@crc-ktfxm-master-0 ~]$ logout
Connection to 192.168.130.11 closed.
$oc rsh pv-pod 
# ls /usr/share/nginx/html
hello.html
# cat /usr/share/nginx/html/hello.html
hello
from crc
```
