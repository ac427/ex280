# Limit Ranges

- Limit range resource defines default, minimum and maximum values for compute resource requests
- Limit range can be set on a project, as well as individual resources
- Limit range can specify cpu,memory for containers and pods and storage for images and pvc
- Difference between quota and limit ranges is limit ranges specifies allowed values for individual resources and quota is for the whole project

```
[abc@foo 07:13:45 - ex-280]$oc create -f limits.yaml 
limitrange/limit-limits created
[abc@foo 07:13:45 - ex-280]$oc get limitrange
NAME           CREATED AT
limit-limits   2021-12-13T12:13:45Z
[abc@foo 07:14:28 - ex-280]$oc describe limitrange limit-limits
Name:                     limit-limits
Namespace:                limits
Type                      Resource                 Min  Max    Default Request  Default Limit  Max Limit/Request Ratio
----                      --------                 ---  ---    ---------------  -------------  -----------------------
Pod                       memory                   1Mi  2Mi    -                -              -
Pod                       cpu                      10m  500m   -                -              -
Container                 cpu                      10m  500m   20m              250m           -
Container                 memory                   5Mi  500Mi  20Mi             200Mi          -
openshift.io/Image        storage                  -    1Gi    -                -              -
openshift.io/ImageStream  openshift.io/images      -    20     -                -              -
openshift.io/ImageStream  openshift.io/image-tags  -    10     -                -              -
PersistentVolumeClaim     storage                  2Gi  50Gi   -                -              -

```


