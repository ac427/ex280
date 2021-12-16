Below are the steps according to openshift docs. ( I installed the operator from gui, install via oc fails)

Doc Ref: Storage -> Configuring persistent storage -> Persistent storage using local volumes 

Even after following, the pvc is still in pending state. Not sure what was wrong. If anyone can figure out, please create a git issue with soltion.


```
$oc new-project local-storage
$oc apply -f lv.yaml 
localvolume.local.storage.openshift.io/local-disks created

$oc get all -n local-storage
NAME                                          READY   STATUS    RESTARTS   AGE
pod/diskmaker-manager-98g2n                   2/2     Running   0          3m14s
pod/local-storage-operator-7c448f99b8-qc6sm   1/1     Running   0          12m

NAME                                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/local-storage-diskmaker-metrics   ClusterIP   10.217.5.204   <none>        8383/TCP   3m14s

NAME                               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/diskmaker-manager   1         1         1       1            1           <none>          3m14s

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/local-storage-operator   1/1     1            1           12m

NAME                                                DESIRED   CURRENT   READY   AGE
replicaset.apps/local-storage-operator-7c448f99b8   1         1         1       12m
$oc get pv | grep local
local-pv-5647ba0b   1000Mi     RWO            Delete           Available                                                         localblock-sc            3m1s
$

$oc apply -f lv.yaml 
localvolume.local.storage.openshift.io/local-disks created
$oc apply -f pvc.yaml 
persistentvolumeclaim/local-pvc-name created
$oc get pvc
NAME             STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS    AGE
local-pvc-name   Pending                                      localblock-sc   4s
$oc describe pvc local-pvc-name
Name:          local-pvc-name
Namespace:     local-storage
StorageClass:  localblock-sc
Status:        Pending
Volume:        
Labels:        <none>
Annotations:   <none>
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      
Access Modes:  
VolumeMode:    Filesystem
Used By:       <none>
Events:
  Type    Reason                Age                From                         Message
  ----    ------                ----               ----                         -------
  Normal  WaitForFirstConsumer  43h (x2 over 43h)  persistentvolume-controller  waiting for first consumer to be created before binding
$oc get pv | grep local
local-pv-5647ba0b   1000Mi     RWO            Delete           Available                                                         localblock-sc            13m
```
