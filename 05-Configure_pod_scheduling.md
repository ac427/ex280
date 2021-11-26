# Pod Scheduling
3 types of rules apply
 - node labels
 - affinity rules
 - anti affinity rules
works through 3 steps
 - Node filter
 - Node prioritizing
 - Select best node: best scoring node is used, if there are more than one round robin used to select one

# NodeSelector - You can use node selector to deploy pods to node or even create projects

```
oc label nodes crc-ktfxm-master-0 env=dev
```

```
oc new-app --name bnginx --image bitnami/nginx
oc scale --replicas=3 deployment/bnginx
```

```
$oc patch deployment bnginx -p '{"spec":{"template":{"spec":{"nodeSelector":{"env": "prod"}}}}}'
deployment.apps/bnginx patched
[abc@foo 09:31:45 - ex-280]$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-854fc5ff67-zckkb   1/1     Running   0          16m
bnginx-86b5cd7466-vnjch   0/1     Pending   0          4s
```
The pod will be in pending state as there is no node with label env=prod

```
$oc describe pod bnginx-86b5cd7466-vnjch | grep Warni
  Warning  FailedScheduling  8s (x2 over 75s)  default-scheduler  0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector.
```


```
[abc@foo 09:33:00 - ex-280]$oc patch deployment bnginx -p '{"spec":{"template":{"spec":{"nodeSelector":{"env": "dev"}}}}}'
deployment.apps/bnginx patched
$oc get pods
NAME                      READY   STATUS              RESTARTS   AGE
bnginx-76dc54cd74-t2lxp   0/1     ContainerCreating   0          2s
bnginx-854fc5ff67-zckkb   1/1     Running             0          18m
$oc get pods
NAME                      READY   STATUS        RESTARTS   AGE
bnginx-76dc54cd74-t2lxp   1/1     Running       0          4s
bnginx-854fc5ff67-zckkb   1/1     Terminating   0          18m
$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-76dc54cd74-t2lxp   1/1     Running   0          5s
```

You can also update the deployment with `oc edit deployment bnginx` and update the yaml file

#### You can also create a project with nodeSelector. All the resources will be created on node with label env=test in below example

```
# to create project with node selector env=test
oc new-project --node-selector env=test
```



