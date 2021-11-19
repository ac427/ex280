# Configure networking components

https://docs.openshift.com/container-platform/4.9/networking/understanding-networking.html


#### Viewing Cluster Network Config

```
$ oc describe network.config/cluster
```

#### View status of Network Operator

```
$ oc describe clusteroperators/network
```


#### Viewing Cluster Network Operator logs

```
$ oc logs --namespace=openshift-network-operator deployment/network-operator

```

# DNS Operator in OpenShift Container Platform

The DNS Operator implements the dns API from the operator.openshift.io API group. The Operator deploys CoreDNS using a daemon set, creates a service for the daemon set, and configures the kubelet to instruct pods to use the CoreDNS service IP address for name resolution.

```
$ oc get -n openshift-dns-operator deployment/dns-operator

$ oc get clusteroperator/dns

$ oc describe dns.operator/default

$ oc edit dns.operator/default

$ oc get configmap/dns-default -n openshift-dns -o yaml

$ oc logs -n openshift-dns-operator deployment/dns-operator -c dns-operator

```
