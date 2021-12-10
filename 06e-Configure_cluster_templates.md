# Templates

To create a bootstrap template

```
$oc login -u kubeadmin -p FV3b7-aTbLJ-UmrWu-aqDGe https://api.crc.testing:6443
$oc new-project templates
$oc adm create-bootstrap-project-template -o yaml > my_template.yaml
```

Edit the template 

```
$wget https://raw.githubusercontent.com/ac427/ex280/master/limitrange.yaml
$diff limitrange.yaml my_template.yaml 
32,49d31
< - apiVersion: v1
<   kind: ResourceQuota
<   metadata:
<     name: ${PROJECT_NAME}-quota
<   spec:
<     hard:
<       cpu: 3
<       memory: 10G
< - apiVersion: v1
<   kind: LimitRange
<   metadata:
<     name: ${PROJECT_NAME}-limits
<   spec:
<     limits:
<       - type: Container
<         defaultRequest:
<           cpu: 30m
<           memory: 30M
 
```
$oc apply -f limitrange.yaml -n openshift-config
$oc get pods -n openshift-config
$oc get template -n openshift-config
```

# update projects.config.openshift.io spec with

```
spec:
  projectRequestTemplate:
    name: project-request
```

```
$oc edit projects.config.openshift.io
# You may have to wait for the pods to restart on openshift-apiserver

```
