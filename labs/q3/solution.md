- login to console as admin
- search for localstorage in the operatorhub and install it with default settings
![local](operator.png)
- create a local storage using the gui ( check local.png). It will give you an error (check err.png)
![local](local.png)

![err](err.png)

- the error is quite clear. It is looking for `spec.storageClassDevices.devicePaths`. Just switch to yaml view and update the devicePath we created in the prep and apply.

![yaml](local-yaml.png)


verify step with oc command

```
$oc get sc
NAME    PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local   kubernetes.io/no-provisioner   Delete          WaitForFirstConsumer   false                  18m

```

as developer user

```
$oc create -f pvc.yaml 
persistentvolumeclaim/pv-example-claim created
$oc get pvc
NAME               STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pv-example-claim   Bound    pv0003   100Gi      RWO,ROX,RWX                   3s
```

# as admin, you can see the q3/pv-example-claim is bound to pv003 instead of the local we just created. to use local, we can mention the storageclass in the pvc.yaml

$oc get pv | grep example
pv0003              100Gi      RWO,ROX,RWX    Recycle          Bound       q3/pv-example-claim                                                           19d
$oc get sc
NAME    PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local   kubernetes.io/no-provisioner   Delete          WaitForFirstConsumer   false                  23m

check  Storage -> Configuring  persistent storage- >  Persistent storage using local volumes in the openshift docs 