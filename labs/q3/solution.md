Below are the steps according to openshift docs. ( I installed the operator from gui, install via oc fails)

Doc Ref: Storage -> Configuring persistent storage -> Persistent storage using local volumes 

Even after following, the pvc is still in pending state. Not sure what was wrong. If anyone can figure out, please create a git issue with soltion.


```
$oc new-project local-storage

$oc apply -f lv.yaml 
localvolume.local.storage.openshift.io/local-disks created
$oc get pv | grep local
local-pv-994b1556   1000Mi     RWO            Delete           Available                                                         local-sc                1s
$oc apply -f pvc.yaml 
persistentvolumeclaim/local-pvc-ex280 created
$oc get pvc
NAME              STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
local-pvc-ex280   Pending                                      local-sc       2s
$oc describe pvc local-pvc-ex280 
Name:          local-pvc-ex280
Namespace:     local-storage
StorageClass:  local-sc
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
  Normal  WaitForFirstConsumer  44h (x2 over 44h)  persistentvolume-controller  waiting for first consumer to be created before binding
$

```

Not sure why it is in pending state even after following the instructions from the docs. Gave up finally. If anyone knows the fix, please create a pr or git issue
