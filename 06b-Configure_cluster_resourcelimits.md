# Resource Limits

```
$oc new-project limits
$oc create deployment  bnginx --image bitnami/nginx --replicas=3
deployment.apps/bnginx created
$oc set resources deployment bnginx --limits=cpu=20m,memory=10Mi --requests=cpu=10m,memory=6Mi
deployment.apps/bnginx resource requirements updated
$oc get pods
NAME                      READY   STATUS              RESTARTS   AGE
bnginx-6d6f7b5db4-cgpq2   0/1     ContainerCreating   0          4s
bnginx-7c9f484f5c-gwhsf   1/1     Running             0          94s
bnginx-7c9f484f5c-mnxqn   1/1     Running             0          94s
bnginx-7c9f484f5c-sq9df   1/1     Running             0          94s
```
Whenever there is a change to deployment, it will do a rolling restart. The old pods are not killed until the new one comes up

The pods failed to start as we requested more than the allowed(limits)

```
$oc describe pod bnginx-6d6f7b5db4-cgpq2 | grep -i warning
  Warning  FailedCreatePodSandBox  12s (x4 over 50s)  kubelet            Failed to create pod sandbox: rpc error: code = Unknown desc = pod set memory limit 10485760 too low; should be at least 12582912
```

To unset the limit, just set the values to zero

```
$oc get pods
NAME                      READY   STATUS              RESTARTS   AGE
bnginx-7c9f484f5c-gwhsf   1/1     Running             0          4m4s
bnginx-7c9f484f5c-mnxqn   1/1     Running             0          4m4s
bnginx-7c9f484f5c-sq9df   1/1     Running             0          4m4s
bnginx-bc49c9bf-d7j6q     0/1     ContainerCreating   0          2s
$oc get pods
NAME                      READY   STATUS              RESTARTS   AGE
bnginx-7c9f484f5c-sq9df   1/1     Running             0          4m17s
bnginx-bc49c9bf-7q9ps     0/1     ContainerCreating   0          5s
bnginx-bc49c9bf-d7j6q     1/1     Running             0          15s
bnginx-bc49c9bf-zf6p8     1/1     Running             0          10s
$oc get pods
NAME                    READY   STATUS    RESTARTS   AGE
bnginx-bc49c9bf-7q9ps   1/1     Running   0          8s
bnginx-bc49c9bf-d7j6q   1/1     Running   0          18s
bnginx-bc49c9bf-zf6p8   1/1     Running   0          13s
```
