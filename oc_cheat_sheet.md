
get cluster info

```
oc get clusterversions
oc describe clusterversions
oc version
oc get clusteroperators
```

to debug nodes

```
oc describe node $NODENAME
oc adm top nodes
oc get node $NODENAME
oc adm node-logs $NODENAME
oc adm node-logs -u crio $NODENAME
oc get routes -n openshift-console
oc whoami --show-console
