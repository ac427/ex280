# Taints
- taint allow a node to refuse a pod unless the Pod has a matching toleration
- taints are applied to nodes through the node spec
- tolerations are applied to a pod using pod spec
- tains and tolerations consist of key,value and an effect
- effect is one of the following
  - NoSchedule
  - PreferNoSchedule
  - NoExecute - No new pods are scheduled and existing pods that doesn't match toleration will be evicted.

Note: NoExecute will kill crc cluster. 
- Use tolerationSeconds to specify how long it takes to evict pods
when NoExecute is specified

# Lab
```
$oc adm taint node crc-ktfxm-master-0 key1=value1:NoSchedule
node/crc-ktfxm-master-0 tainted
$oc run test-taint --image=bitnami/nginx
pod/test-taint created
$oc describe pod test-taint | grep Warning
  Warning  FailedScheduling  64s   default-scheduler  0/1 nodes are available: 1 node(s) had taint {key1: value1}, that the pod didn't tolerate.
```

```
oc adm taint node crc-ktfxm-master-0 key1-
node/crc-ktfxm-master-0 untainted
```
