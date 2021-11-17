### RBAC (Role Based Access Control)

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
