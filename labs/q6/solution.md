# verify secret name in oauth cluster

```
$oc get oauth cluster -o yaml -o jsonpath="{.spec.identityProviders}"
[{"htpasswd":{"fileData":{"name":"localusers"}},"mappingMethod":"claim","name":"ex280-users","type":"HTPasswd"}]$
```

```
$oc extract secret/localusers --to /tmp -n openshift-config --confirm
/tmp/htpasswd
```

```
$cat /tmp/htpasswd
abc:$2y$05$Z5iHP5cXTQFo7Cnun.EcrOcWfpVgjtuoWTBsuHhgaeuLBKVmNNL7K
linda:$2y$05$67nC9i1vh1CRv42Gp3DR3eHrMBbPwhlExp4yMqMxZbWo2ilHlcllW

$htpasswd -D /tmp/htpasswd linda
Deleting password for user linda
$htpasswd -bB /tmp/htpasswd lee passw0rd
Adding password for user lee
$htpasswd -bB /tmp/htpasswd robin passw0rd
Adding password for user robin
$htpasswd -bB /tmp/htpasswd jack passw0rd
Adding password for user jack
$cat /tmp/htpasswd 
abc:$2y$05$Z5iHP5cXTQFo7Cnun.EcrOcWfpVgjtuoWTBsuHhgaeuLBKVmNNL7K
lee:$2y$05$a7dMFKmqMk1ijGbatqmd7ODlnbM.IOZJIxeUThG4xo8fJ6tADO6HG
robin:$2y$05$rT/abGBcuNf3hAw99IhRZub4y3Bkjyr9X/Cd76l9oNNyrowx/XUjq
jack:$2y$05$X4bYYqHTJTIjyzPnVs0Xj.nDSh6opExdv9rGb84MnK67Sd3Z7cu4O
```

you can run --dry-run=client and verify formating and the data
```
$oc get secret/localusers -o yaml -n openshift-config 
apiVersion: v1
data:
  htpasswd: YWJjOiQyeSQwNSRaNWlIUDVjWFRRRm83Q251bi5FY3JPY1dmcFZnanR1b1dUQnN1SGhnYWV1TEJLVm1OTkw3SwpsaW5kYTokMnkkMDUkNjduQzlpMXZoMUNSdjQyR3AzRFIzZUhyTUJiUHdobEV4cDR5TXFNeFpiV28yaWxIbGNsbFcK
kind: Secret
metadata:
  creationTimestamp: "2021-12-14T20:37:56Z"
  name: localusers
  namespace: openshift-config
  resourceVersion: "35701"
  uid: c7d9cc5c-adb6-4b8e-9705-daddd3d78357
type: Opaque

$oc set data secret/localusers --from-file /tmp/htpasswd --dry-run=client -o yaml -n openshift-config
apiVersion: v1
data:
  htpasswd: YWJjOiQyeSQwNSRaNWlIUDVjWFRRRm83Q251bi5FY3JPY1dmcFZnanR1b1dUQnN1SGhnYWV1TEJLVm1OTkw3SwpqYWNrOiQyeSQwNSQwSDhLbG83UlhNLzA0dEFCWTZnRzFlaUdBb093N3dnUGdpUndWYjlOL1FyeEFZRVRrbzBneQpyb2JpbjokMnkkMDUkTGVISjVBZElsTUJ0a2JzMHhkRlR1dTdIb21MYkM3elBoYnJtUUpaMmN1UGg4a1lGd29GY1cKbGVlOiQyeSQwNSRwS0U0VlEycFNSSW1EWTRzWE1TMVZPc3dhelNZWnpNVm4zcVVmYlpGRHl5NkVTLjV1SlJrLgo=
kind: Secret
metadata:
  creationTimestamp: "2021-12-14T20:37:56Z"
  name: localusers
  namespace: openshift-config
  resourceVersion: "35701"
  uid: c7d9cc5c-adb6-4b8e-9705-daddd3d78357
type: Opaque

$echo YWJjOiQyeSQwNSRaNWlIUDVjWFRRRm83Q251bi5FY3JPY1dmcFZnanR1b1dUQnN1SGhnYWV1TEJLVm1OTkw3SwpqYWNrOiQyeSQwNSQwSDhLbG83UlhNLzA0dEFCWTZnRzFlaUdBb093N3dnUGdpUndWYjlOL1FyeEFZRVRrbzBneQpyb2JpbjokMnkkMDUkTGVISjVBZElsTUJ0a2JzMHhkRlR1dTdIb21MYkM3elBoYnJtUUpaMmN1UGg4a1lGd29GY1cKbGVlOiQyeSQwNSRwS0U0VlEycFNSSW1EWTRzWE1TMVZPc3dhelNZWnpNVm4zcVVmYlpGRHl5NkVTLjV1SlJrLgo= | base64 -d
abc:$2y$05$Z5iHP5cXTQFo7Cnun.EcrOcWfpVgjtuoWTBsuHhgaeuLBKVmNNL7K
jack:$2y$05$0H8Klo7RXM/04tABY6gG1eiGAoOw7wgPgiRwVb9N/QrxAYETko0gy
robin:$2y$05$LeHJ5AdIlMBtkbs0xdFTuu7HomLbC7zPhbrmQJZ2cuPh8kYFwoFcW
lee:$2y$05$pKE4VQ2pSRImDY4sXMS1VOswazSYZzMVn3qUfbZFDyy6ES.5uJRk.
```

# set the new secret and verify pods in openshift-authentication namespace

```
$oc set data secret/localusers --from-file /tmp/htpasswd -o yaml -n openshift-config
apiVersion: v1
data:
  htpasswd: YWJjOiQyeSQwNSRaNWlIUDVjWFRRRm83Q251bi5FY3JPY1dmcFZnanR1b1dUQnN1SGhnYWV1TEJLVm1OTkw3SwpqYWNrOiQyeSQwNSQwSDhLbG83UlhNLzA0dEFCWTZnRzFlaUdBb093N3dnUGdpUndWYjlOL1FyeEFZRVRrbzBneQpyb2JpbjokMnkkMDUkTGVISjVBZElsTUJ0a2JzMHhkRlR1dTdIb21MYkM3elBoYnJtUUpaMmN1UGg4a1lGd29GY1cKbGVlOiQyeSQwNSRwS0U0VlEycFNSSW1EWTRzWE1TMVZPc3dhelNZWnpNVm4zcVVmYlpGRHl5NkVTLjV1SlJrLgo=
kind: Secret
metadata:
  creationTimestamp: "2021-12-14T20:37:56Z"
  name: localusers
  namespace: openshift-config
  resourceVersion: "82580"
  uid: c7d9cc5c-adb6-4b8e-9705-daddd3d78357
type: Opaque

oc get pods -n openshift-authentication -w
NAME                               READY   STATUS    RESTARTS   AGE
oauth-openshift-68d5b7b66c-bt9mq   1/1     Running   0          46s

```

# Login as any new user

```
$oc login -u lee -p passw0rd
Login successful.

```

# as admin

```
$oc adm groups new managers
group.user.openshift.io/managers created
$oc adm groups add-users managers robin
group.user.openshift.io/managers added: "robin"

$oc adm groups new developers
group.user.openshift.io/developers created
$oc adm groups add-users developers jack
group.user.openshift.io/developers added: "jack"

$oc adm policy add-cluster-role-to-group edit developers
clusterrole.rbac.authorization.k8s.io/edit added: "developers"

# get clusterrolebindings self-provisioner 

$oc get clusterrolebindings self-provisioner -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: "2021-12-14T21:15:16Z"
  name: self-provisioner
  resourceVersion: "42983"
  uid: 602d603f-80f7-449f-a376-d6a39c29b8bf
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: self-provisioner
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: system:authenticated:oauth

# add managers to self-provisioner

$oc adm policy add-cluster-role-to-group  self-provisioner managers
clusterrole.rbac.authorization.k8s.io/self-provisioner added: "managers"

# remove the default system:authenticated:oauth from self-provisioner. Make sure to restore this at the end of the lab.

$oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
clusterrole.rbac.authorization.k8s.io/self-provisioner removed: "system:authenticated:oauth"
$oc get clusterrolebindings self-provisioner -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: "2021-12-14T21:15:16Z"
  name: self-provisioner
  resourceVersion: "88411"
  uid: 602d603f-80f7-449f-a376-d6a39c29b8bf
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: self-provisioner
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: Group
  name: managers

```

# Verify

```
$oc login -u lee -p passw0rd
Login successful.

You have access to 69 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "testing1".
$oc get nodes
NAME                 STATUS   ROLES           AGE   VERSION
crc-x4qnm-master-0   Ready    master,worker   20d   v1.22.2+5e38c72

```

# as user abc

```
$oc adm groups new operators
group.user.openshift.io/operators created
$oc adm groups add-users operators lee
group.user.openshift.io/operators added: "lee"
$oc adm policy remove-
remove-cluster-role-from-group  remove-group                    remove-role-from-user           remove-scc-from-user            
remove-cluster-role-from-user   remove-role-from-group          remove-scc-from-group           remove-user                     
$oc adm policy remove-cluster-role-from-user cluster-admin lee
clusterrole.rbac.authorization.k8s.io/cluster-admin removed: "lee"
$oc adm policy add-cluster-role-to-group view operators
clusterrole.rbac.authorization.k8s.io/view added: "operators"

```

```
$oc login -u lee -p passw0rd
Login successful.

You have access to 69 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "testing1".
$
$oc new-project testing2
Error from server (Forbidden): You may not request a new project via this API.
```


# robin has no admin, fails to list nodes, but can create new-projects

```
$oc login -u robin -p passw0rd
Login successful.

You have one project on this server: "testing"

Using project "testing".
$oc get nodes
Error from server (Forbidden): nodes is forbidden: User "robin" cannot list resource "nodes" in API group "" at the cluster scope
$oc new-project testing3
Now using project "testing3" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

```

# Restore settings and verify lee can create new-projects. Ignore the warning


```
$oc adm policy add-cluster-role-to-group  self-provisioner system:authenticated:oauth
Warning: Group 'system:authenticated:oauth' not found
clusterrole.rbac.authorization.k8s.io/self-provisioner added: "system:authenticated:oauth"
$oc login -u lee -p passw0rd
Login successful.

You have access to 70 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "testing3".
$oc new-project testing
Error from server (AlreadyExists): project.project.openshift.io "testing" already exists
$oc new-project testing5
Now using project "testing5" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname
```
