# Manual scaling of pods

```
$oc get deployment
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
bnginx   1/1     1            1           102m
$oc scale --replicas=2 deployment/bnginx
deployment.apps/bnginx scaled
$oc get deployment
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
bnginx   1/2     2            1           102m
```

You can also update the yaml with `oc edit deployment bnginx` and update `replicas: x`

# AutoScaling

#### HorizontalPodAutoScaler(HPA)

HPA resource updated replicas depending on defined metrics of cpu and memory usage of pods

#### Metric api is disabled in crc. To enable bump the default memory to min of 14G and restart crc (your system may slow down depending on your workstation)

```
$ crc config set enable-cluster-monitoring true
$ crc config set memory 14336
$ crc stop && crc start
```

```

$oc new-app --name bnginx --image bitnami/nginx
$oc autoscale deployment bnginx --min=1 --max=5 --cpu-percent=10
horizontalpodautoscaler.autoscaling/bnginx autoscaled
$oc get hpa
NAME     REFERENCE           TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
bnginx   Deployment/bnginx   <unknown>/10%   1         5         0          4s
```

`oc autoscale` is applying autoscaling/v1 api

applied fix  https://access.redhat.com/solutions/5428871 and it works for few target resource. It changed the unknown when target type is set to AverageValue, but was still applying  `apiVersion: autoscaling/v1`. It doesn't work for type Utilization. I think it is issue with CRC cluster.

```
$oc describe hpa  | grep Warning
  Warning  FailedComputeMetricsReplicas  76m (x12 over 78m)     horizontal-pod-autoscaler  invalid metrics (1 invalid out of 1), first error is: failed to get cpu utilization: missing request for cpu
  Warning  FailedGetResourceMetric       3m56s (x300 over 78m)  horizontal-pod-autoscaler  failed to get cpu utilization: missing request for cpu

```

```
$oc delete hpa bnginx
horizontalpodautoscaler.autoscaling "bnginx" deleted
$cat bnginx-hpa.yaml 
apiVersion: autoscaling/v2beta2 
kind: HorizontalPodAutoscaler
metadata:
  name: bnginx
  namespace: hpa
spec:
  maxReplicas: 5
  minReplicas: 1
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: bnginx
  metrics: 
  - type: Resource
    resource:
      name: cpu 
      target:
        type: AverageValue
        averageValue: 5m

$oc apply -f bnginx-hpa.yaml 
horizontalpodautoscaler.autoscaling/bnginx created
# AFTER A MIN OR SO
$oc get hpa
NAME     REFERENCE           TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
bnginx   Deployment/bnginx   0/5m      1         5         1          72s

$oc adm top pods
NAME                      CPU(cores)   MEMORY(bytes)   
bnginx-854fc5ff67-6gpdj   0m           5Mi   
```

# Lets bumpup the memory by running yes
`oc rsh bnginx-854fc5ff67-6gpdj yes`

In new terminal after few min (9m1s)

```
$oc get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-854fc5ff67-6gpdj   1/1     Running   0          9m14s
bnginx-854fc5ff67-z8p5j   1/1     Running   0          13s
```
The pods to scale down after few min once you kill rsh and the avg cpu util goes down
