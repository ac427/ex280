# Solution 1

```
$oc create quota cm-quota --hard=configmaps=6
resourcequota/cm-quota created
```

There are already two cm

```
$oc get cm
NAME                       DATA   AGE
kube-root-ca.crt           1      2m25s
openshift-service-ca.crt   1      2m25s

```
lets write some random cm

```
$for i in $(seq 1 5);do oc create configmap foo$i --from-literal=key$i=config$i;done
configmap/foo1 created
configmap/foo2 created
configmap/foo3 created
configmap/foo4 created
error: failed to create configmap: configmaps "foo5" is forbidden: exceeded quota: cm-quota, requested: configmaps=1, used: configmaps=6, limited: configmaps=6
```

# Solution 2

```
$oc adm create-bootstrap-project-template -o yaml > template.yaml
$oc create quota foo --hard=cpu=1,memory=200Mi,pods=2 --dry-run -o yaml

```
update the dry-run output in template.yaml


`$oc apply -f template.yaml -n openshift-config`

now update the spec: {} with below  by running `oc edit projects.config.openshift.io cluster`

```
spec:
  projectRequestTemplate:
    name: project-request

```

