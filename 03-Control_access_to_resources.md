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

### Add clusterrole to user. Grant user Joe to list pods in all-namespaces

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

### Create a deployment and use env from secrets

```
$oc create secret generic mysql --from-literal password=password --from-literal database=mydb --from-literal hostname=mysql --from-literal root_password=password
secret/mysql created
$oc new-app --name mysql --docker-image bitnami/mysql 
Flag --docker-image has been deprecated, Deprecated flag use --image
--> Found container image 62288cd (20 hours old) from Docker Hub for "bitnami/mysql"

    * An image stream tag will be created as "mysql:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "mysql" created
    deployment.apps "mysql" created
    service "mysql" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/mysql' 
    Run 'oc status' to view your app.

```

#### Pod crashed!!!
```
$oc get pods
NAME                     READY   STATUS             RESTARTS      AGE
mysql-59cdc6d744-rwb49   0/1     CrashLoopBackOff   3 (30s ago)   99s
$oc logs mysql-59cdc6d744-rwb49
mysql 01:08:50.03 
mysql 01:08:50.03 Welcome to the Bitnami mysql container
mysql 01:08:50.03 Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-mysql
mysql 01:08:50.03 Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-mysql/issues
mysql 01:08:50.03 
mysql 01:08:50.04 INFO  ==> ** Starting MySQL setup **
mysql 01:08:50.07 INFO  ==> Validating settings in MYSQL_*/MARIADB_* env vars
mysql 01:08:50.07 ERROR ==> The MYSQL_ROOT_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development.
```


```

$oc set env deployment/mysql --from secret/mysql --prefix MYSQL_
deployment.apps/mysql updated
$oc get pods
NAME                     READY   STATUS    RESTARTS   AGE
mysql-58dd56878f-8hf2s   1/1     Running   0          10s

```


```
$oc rsh mysql-58dd56878f-8hf2s env | grep MYSQL
MYSQL_HOSTNAME=mysql
MYSQL_PASSWORD=password
MYSQL_ROOT_PASSWORD=password
MYSQL_DATABASE=mydb
MYSQL_PORT=tcp://10.217.4.19:3306
MYSQL_PORT_3306_TCP=tcp://10.217.4.19:3306
MYSQL_SERVICE_HOST=10.217.4.19
MYSQL_SERVICE_PORT=3306
MYSQL_PORT_3306_TCP_PORT=3306
MYSQL_PORT_3306_TCP_ADDR=10.217.4.19
MYSQL_SERVICE_PORT_3306_TCP=3306
MYSQL_PORT_3306_TCP_PROTO=tcp
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

# Service Accounts

```
# -n namespace_name is optional
$oc create sa mysa
serviceaccount/mysa created
$oc get sa
NAME       SECRETS   AGE
builder    2         10h
default    2         10h
deployer   2         10h
mysa       2         50s
```
# Manging Security Context Constraints (SCC)

SCC is an OpenShift resource similar to Kubernetes Security Context, that restrics access to resources

- Diffrent SCCs are available to control
  - Running root containers
  - Usinghost dir as volumes
  - Changing the User ID
  - Changing SELinux context of a container

```
$oc get scc
NAME                              PRIV    CAPS         SELINUX     RUNASUSER          FSGROUP     SUPGROUP    PRIORITY     READONLYROOTFS   VOLUMES
anyuid                            false   <no value>   MustRunAs   RunAsAny           RunAsAny    RunAsAny    10           false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
hostaccess                        false   <no value>   MustRunAs   MustRunAsRange     MustRunAs   RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","hostPath","persistentVolumeClaim","projected","secret"]
hostmount-anyuid                  false   <no value>   MustRunAs   RunAsAny           RunAsAny    RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","hostPath","nfs","persistentVolumeClaim","projected","secret"]
hostnetwork                       false   <no value>   MustRunAs   MustRunAsRange     MustRunAs   MustRunAs   <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
machine-api-termination-handler   false   <no value>   MustRunAs   RunAsAny           MustRunAs   MustRunAs   <no value>   false            ["downwardAPI","hostPath"]
nonroot                           false   <no value>   MustRunAs   MustRunAsNonRoot   RunAsAny    RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
privileged                        true    ["*"]        RunAsAny    RunAsAny           RunAsAny    RunAsAny    <no value>   false            ["*"]
restricted                        false   <no value>   MustRunAs   MustRunAsRange     MustRunAs   RunAsAny    <no value>   false            ["configMap","downwardAPI","emptyDir","persistentVolumeClaim","projected","secret"]
```

#### see the SCC in use by pod

```
oc describe pod <podname> | grep scc to
```
#### If the pod is crashing because of SCC. You can debug with below

```
oc get pod <podname> -o yaml | oc adm policy scc-subject-review -f -
```

#### Once SA is connected to SCC it can be bound to a deployment or pod

### Lab: run new-app using docker image nginx which runs a root

```
$oc new-app --name scc-nginx --image nginx
--> Found container image ea335ee (39 hours old) from Docker Hub for "nginx"

    * An image stream tag will be created as "scc-nginx:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "scc-nginx" created
    deployment.apps "scc-nginx" created
    service "scc-nginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/scc-nginx' 
    Run 'oc status' to view your app.
$oc get pods
NAME                         READY   STATUS   RESTARTS   AGE
scc-nginx-6865677ffb-5knl5   0/1     Error    0          3s
$oc logs scc-nginx-6865677ffb-5knl5
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: can not modify /etc/nginx/conf.d/default.conf (read-only file system?)
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/11/19 01:58:51 [warn] 1#1: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
2021/11/19 01:58:51 [emerg] 1#1: mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
$oc get pod scc-nginx-6865677ffb-5knl5 -o yaml | oc adm policy scc-subject-review -f -
RESOURCE                         ALLOWED BY   
Pod/scc-nginx-6865677ffb-5knl5   anyuid       
$oc create sa sa-nginx
serviceaccount/sa-nginx created
$oc adm policy add-scc-to-user anyuid -z sa-nginx
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:anyuid added: "sa-nginx"
$oc set sa deployment/scc-nginx sa-nginx
deployment.apps/scc-nginx serviceaccount updated
$oc get pods
NAME                         READY   STATUS        RESTARTS   AGE
scc-nginx-6865677ffb-5knl5   0/1     Terminating   5          3m25s
scc-nginx-79969c749b-fkxps   1/1     Running       0          3s

```
