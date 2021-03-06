```
$oc new-project users
Now using project "users" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

$oc extract secret/htpass-secret -n openshift-config --to=/tmp
/tmp/htpasswd
$htpasswd -bB /tmp/htpasswd joe passw0rd
Adding password for user joe
$htpasswd -bB /tmp/htpasswd abc passw0rd
Adding password for user abc
$htpasswd -bB /tmp/htpasswd linda passw0rd
Adding password for user linda

$oc set data secret/htpass-secret -n openshift-config --from-file /tmp/htpasswd
secret/htpass-secret data updated

$oc rollout restart deployment/oauth-openshift  -n openshift-authentication
deployment.apps/oauth-openshift restarted


$oc get pods -n openshift-authentication
NAME                               READY   STATUS    RESTARTS   AGE
oauth-openshift-66fdcbc8fb-n44f9   1/1     Running   0          60s

$oc login -u joe -p passw0rd https://api.crc.testing:6443
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

$oc login -u linda -p passw0rd https://api.crc.testing:6443
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

$oc login -u abc -p passw0rd https://api.crc.testing:6443
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>


```

```
$oc login -u kubeadmin -p bMQh7-zfaiL-ghEDw-zNRui https://api.crc.testing:6443
Login successful.

You have access to 65 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
$
$oc adm policy add-cluster-role-to-user cluster-admin abc
clusterrole.rbac.authorization.k8s.io/cluster-admin added: "abc"
$oc login -u abc -p passw0rd https://api.crc.testing:6443
Login successful.

You have access to 65 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "default".
```


# Now lets delete kubeadmin as user abc who is cluster admin

Note: doc says to run below, but there is no such secret in crc cluster

`oc delete secrets kubeadmin -n kube-system`


```
$htpasswd -D /tmp/htpasswd kubeadmin
Deleting password for user kubeadmin

$oc set data secret/htpass-secret -n openshift-config --from-file /tmp/htpasswd
secret/htpass-secret data updated
$oc rollout restart deployment/oauth-openshift  -n openshift-authentication
deployment.apps/oauth-openshift restarted


$oc delete identities developer:kubeadmin
identity.user.openshift.io "developer:kubeadmin" deleted

$oc delete user kubeadmin
user.user.openshift.io "kubeadmin" deleted

```



# Part 2


```
$cat /tmp/htpasswd 
abc:$2y$05$Z5iHP5cXTQFo7Cnun.EcrOcWfpVgjtuoWTBsuHhgaeuLBKVmNNL7K
linda:$2y$05$67nC9i1vh1CRv42Gp3DR3eHrMBbPwhlExp4yMqMxZbWo2ilHlcllW
$oc create secret generic localusers --from-file /tmp/htpasswd -n openshift-config
```

`oc edit oauth cluster` and update with spec.identityProviders[0].htpasswd.fileData.name and spec.identityProviders[0].htpasswd/name


```
spec:
  identityProviders:
  - htpasswd:
      fileData:
        name: localusers
    mappingMethod: claim
    name: ex280-users
    type: HTPasswd
```


The pods should restart after the upate. You can also manually kick with below.

```
$oc rollout restart deployment/oauth-openshift  -n openshift-authentication
deployment.apps/oauth-openshift restarted

```

Relogin as user abc

```
NAME                    IDP NAME      IDP USER NAME   USER NAME   USER UID
ex280-users:abc         ex280-users   abc             abc         05c8ba59-9e2b-436d-bd88-ea5bf387d3cc
ex280-users:developer   ex280-users   developer       developer   f7aad4d4-41d2-4f3b-a408-e1f046901087
```
