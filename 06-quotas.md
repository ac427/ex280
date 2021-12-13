#Quotas

```
oc login -u joe -p passw0rd https://api.crc.testing:6443
Login successful.

$oc new-project quota
Now using project "quota" on server "https://api.crc.testing:6443".

```

as admin ( quotas can be set only as admin)

```
$oc login -u kubeadmin -p okXhH-ViKrH-TVSn6-UHH9u https://api.crc.testing:6443
$oc create quota user-quota --hard=cpu=500m,memory=100Mi,pods=2
resourcequota/user-quota created

```

switch back to regular user joe

```
oc new-app --name=test-quota --image=bitnami/nginx
--> Found container image 64641ad (4 hours old) from Docker Hub for "bitnami/nginx"

    * An image stream tag will be created as "test-quota:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "test-quota" created
    deployment.apps "test-quota" created
    service "test-quota" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/test-quota' 
    Run 'oc status' to view your app.
$oc get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
test-quota   0/1     0            0           10s
```
no reason why 0/1 in `$oc describe deployment test-quota`


```

$oc get replicasets.apps 
NAME                    DESIRED   CURRENT   READY   AGE
test-quota-79f497bdd5   1         0         0       79s
test-quota-86775b66f8   1         0         0       80s
$oc describe rs test-quota-79f497bdd5 | grep Warning
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-k7fnl" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-2jfw4" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-2vsls" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-lmz42" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-vzssn" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-mhkjt" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-lw52t" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  92s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-qzcdd" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  91s                replicaset-controller  Error creating: pods "test-quota-79f497bdd5-pjqs7" is forbidden: failed quota: user-quota: must specify cpu,memory
  Warning  FailedCreate  20s (x6 over 90s)  replicaset-controller  (combined from similar events): Error creating: pods "test-quota-79f497bdd5-dqtbc" is forbidden: failed quota: user-quota: must specify cpu,memory
```


```
$oc get resourcequotas 
NAME         AGE     REQUEST                                   LIMIT
user-quota   4m49s   cpu: 0/500m, memory: 0/100Mi, pods: 0/2   
```

```
$oc set resources deployment/test-quota --limits=cpu=100m,memory=50Mi --requests=cpu=50m,memory=40Mi
deployment.apps/test-quota resource requirements updated
$oc get pods
NAME                          READY   STATUS    RESTARTS   AGE
test-quota-7555f5f8fd-64s2g   1/1     Running   0          6s
$oc get deployment test-quota 
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
test-quota   1/1     1            1           4m
```
