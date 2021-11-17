# RBAC (Role Based Access Control)

Read about Role, ClusterRole, RoleBindings and ClusterRoleBinding in https://kubernetes.io/docs/reference/access-authn-authz/rbac

### Lab: add user joe and give permissions to list all pods in all namespaces

```
$oc extract secret/htpass-secret --to=/tmp --confirm=true -n openshift-config
/tmp/htpasswd
$htpasswd -b -B /tmp/htpasswd joe passw0rd
Adding password for user joe
```

```
$oc set data secret/htpass-secret --from-file=/tmp/htpasswd  -n openshift-config
secret/htpass-secret data updated
```

```
$oc get deployments -n openshift-authentication
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
oauth-openshift   1/1     1            1           10d
$oc rollout restart deployment/oauth-openshift -n openshift-authentication
deployment.apps/oauth-openshift restarted
```

```
$oc login -u joe -p passw0rd
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

$oc whoami
joe
```

### Add Joe to list all pods in all-namespaces

```
$oc login -u kubeadmin -p FV3b7-aTbLJ-UmrWu-aqDGe https://api.crc.testing:6443
Login successful.

$oc create clusterrole ex280-pod-reader --verb=get,list,watch --resource=pods
clusterrole.rbac.authorization.k8s.io/ex280-pod-reader created

$oc create clusterrolebinding ex280-pod-reader --clusterrole=ex280-pod-reader  --group=system:authenticated
clusterrolebinding.rbac.authorization.k8s.io/ex280-pod-reader created

$oc policy add-role-to-user ex280-pod-reader joe
clusterrole.rbac.authorization.k8s.io/ex280-pod-reader added: "joe"
$oc login -u joe -p passw0rd
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

$oc get pods --all-namespaces | wc -l
67

```




# Secrets

https://kubernetes.io/docs/concepts/configuration/secret/

A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in a container image. Using a Secret means that you don't need to include confidential data in your application code.

Secrets are similar to ConfigMaps but are specifically intended to hold confidential data.


|Builtin | Type |	Usage |
| ------ | ------ |
|Opaque |	arbitrary user-defined data|
|kubernetes.io/service-account-token |	service account token |
|kubernetes.io/dockercfg | 	serialized ~/.dockercfg file |
|kubernetes.io/dockerconfigjson | 	serialized ~/.docker/config.json file |
|kubernetes.io/basic-auth | 	credentials for basic authentication |
|kubernetes.io/ssh-auth | 	credentials for SSH authentication |
kubernetes.io/tls | 	data for a TLS client or server |
|bootstrap.kubernetes.io/token |	bootstrap token data |

```
$oc create secret generic empty-secret
secret/empty-secret created
$oc get secrets empty-secret
NAME           TYPE     DATA   AGE
empty-secret   Opaque   0      7s
# Data field shows the number of items in the secret
$oc set data secret empty-secret foo=bar
secret/empty-secret data updated
$oc get secrets empty-secret
NAME           TYPE     DATA   AGE
empty-secret   Opaque   1      19s
$oc set data secret empty-secret abc=qux
secret/empty-secret data updated
$oc get secrets empty-secret
NAME           TYPE     DATA   AGE
empty-secret   Opaque   2      32s
$oc get secrets empty-secret -o yaml
apiVersion: v1
data:
  abc: cXV4
  foo: YmFy
kind: Secret
metadata:
  creationTimestamp: "2021-11-17T20:14:06Z"
  name: empty-secret
  namespace: ex280
  resourceVersion: "247178"
  uid: 1887e73c-6f31-4cd6-998e-e43163e97707
type: Opaque
```
