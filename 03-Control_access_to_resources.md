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

#### To view the Users in clusterrolebinding ( Eventhough we created clusterrolebinding, `oc describe clusterrolebinding` is not showing ex280-pod-reader. Not sure if it is bug or my misunderstanding. Below command shows the Kind as ClusterRole though)

```
$oc describe rolebinding.rbac ex280-pod-reader
Name:         ex280-pod-reader
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  ClusterRole
  Name:  ex280-pod-reader
Subjects:
  Kind  Name  Namespace
  ----  ----  ---------
  User  joe

```





# Secrets

Read about about secrets in https://kubernetes.io/docs/concepts/configuration/secret/

A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in a container image. Using a Secret means that you don't need to include confidential data in your application code.

Secrets are similar to ConfigMaps but are specifically intended to hold confidential data.

Kubernetes Secret Types

|Builtin Type |	Usage |
| ------ | ------ |
|Opaque |	arbitrary user-defined data|
|kubernetes.io/service-account-token |	service account token |
|kubernetes.io/dockercfg | 	serialized ~/.dockercfg file |
|kubernetes.io/dockerconfigjson | 	serialized ~/.docker/config.json file |
|kubernetes.io/basic-auth | 	credentials for basic authentication |
|kubernetes.io/ssh-auth | 	credentials for SSH authentication |
kubernetes.io/tls | 	data for a TLS client or server |
|bootstrap.kubernetes.io/token |	bootstrap token data |

Options Available on `oc create secret`

|  Type |	Usage |
| ------ | ------ |
| docker-registry |Create a secret for use with a Docker registry |
| generic  |       Create a secret from a local file, directory, or literal value |
| tls      |       Create a TLS secret |


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
#### Check the help page for configuring docker auth
```
$oc create secret docker-registry -h
```


# Lab: add user linda and create group qa-users and grand cluseterrole view to qa-users

#### skipping the user creation

#### on first login
```
$oc login -u linda -p password
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

$oc get all
Error from server (Forbidden): replicationcontrollers is forbidden: User "linda" cannot list resource "replicationcontrollers" in API group "" in the namespace "default"
Error from server (Forbidden): services is forbidden: User "linda" cannot list resource "services" in API group "" in the namespace "default"
Error from server (Forbidden): daemonsets.apps is forbidden: User "linda" cannot list resource "daemonsets" in API group "apps" in the namespace "default"
Error from server (Forbidden): deployments.apps is forbidden: User "linda" cannot list resource "deployments" in API group "apps" in the namespace "default"
Error from server (Forbidden): replicasets.apps is forbidden: User "linda" cannot list resource "replicasets" in API group "apps" in the namespace "default"
Error from server (Forbidden): statefulsets.apps is forbidden: User "linda" cannot list resource "statefulsets" in API group "apps" in the namespace "default"
Error from server (Forbidden): horizontalpodautoscalers.autoscaling is forbidden: User "linda" cannot list resource "horizontalpodautoscalers" in API group "autoscaling" in the namespace "default"
Error from server (Forbidden): cronjobs.batch is forbidden: User "linda" cannot list resource "cronjobs" in API group "batch" in the namespace "default"
Error from server (Forbidden): jobs.batch is forbidden: User "linda" cannot list resource "jobs" in API group "batch" in the namespace "default"
Error from server (Forbidden): deploymentconfigs.apps.openshift.io is forbidden: User "linda" cannot list resource "deploymentconfigs" in API group "apps.openshift.io" in the namespace "default"
Error from server (Forbidden): buildconfigs.build.openshift.io is forbidden: User "linda" cannot list resource "buildconfigs" in API group "build.openshift.io" in the namespace "default"
Error from server (Forbidden): builds.build.openshift.io is forbidden: User "linda" cannot list resource "builds" in API group "build.openshift.io" in the namespace "default"
Error from server (Forbidden): imagestreams.image.openshift.io is forbidden: User "linda" cannot list resource "imagestreams" in API group "image.openshift.io" in the namespace "default"
Error from server (Forbidden): routes.route.openshift.io is forbidden: User "linda" cannot list resource "routes" in API group "route.openshift.io" in the namespace "default"

```

#### as admin


```
$oc adm groups new  qa-users
group.user.openshift.io/qa-users created
$oc policy add-role-to-group view qa-users
clusterrole.rbac.authorization.k8s.io/view added: "qa-users"

```

#### as linda


```

$oc login -u linda -p password
Login successful.

You have one project on this server: "default"

Using project "default".
$oc get all
NAME                 TYPE           CLUSTER-IP   EXTERNAL-IP                            PORT(S)   AGE
service/kubernetes   ClusterIP      10.217.4.1   <none>                                 443/TCP   10d
service/openshift    ExternalName   <none>       kubernetes.default.svc.cluster.local   <none>    10d
```
