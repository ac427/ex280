As admin user abc

```
[abc@foo 17:55:20 - q5]$oc whoami
abc
[abc@foo 17:55:32 - q5]$oc new-project support
Now using project "support" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

[abc@foo 17:55:49 - q5]$oc adm policy add-role-to-user admin linda
clusterrole.rbac.authorization.k8s.io/admin added: "linda"
[abc@foo 17:56:12 - q5]$oc describe clusterrolebindings self-provisioners
Name:         self-provisioners
Labels:       <none>
Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
Role:
  Kind:  ClusterRole
  Name:  self-provisioner
Subjects:
  Kind   Name                        Namespace
  ----   ----                        ---------
  Group  system:authenticated:oauth  
[abc@foo 17:57:56 - q5]$oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth 
Warning: Your changes may get lost whenever a master is restarted, unless you prevent reconciliation of this rolebinding using the following command: oc annotate clusterrolebinding.rbac self-provisioners 'rbac.authorization.kubernetes.io/autoupdate=false' --overwrite
clusterrole.rbac.authorization.k8s.io/self-provisioner removed: "system:authenticated:oauth"
```

# Login as user linda and try creating new project. It should fail. Then try deploying app in support project

```
[abc@foo 17:59:10 - q5]$oc login -u linda -p passw0rd
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    foo
  * support

Using project "support".
[abc@foo 17:59:21 - q5]$oc new-project testing
Error from server (Forbidden): You may not request a new project via this API.
[abc@foo 17:59:26 - q5]$oc new-app bitnami/nginx
--> Found container image 4173d05 (4 hours old) from Docker Hub for "bitnami/nginx"

    * An image stream tag will be created as "nginx:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "nginx" created
    deployment.apps "nginx" created
    service "nginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/nginx' 
    Run 'oc status' to view your app.
```



# Restore previous settings and try creating project as user linda

```
[abc@foo 18:02:55 - q5]$oc login -u abc -p passw0rd
Login successful.

You have access to 66 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "support".
[abc@foo 18:03:00 - q5]$oc adm policy add-cluster-role-to-group self-provisioner system:authenticated:oauth
Warning: Group 'system:authenticated:oauth' not found
clusterrole.rbac.authorization.k8s.io/self-provisioner added: "system:authenticated:oauth"
[abc@foo 18:03:03 - q5]$oc login -u linda -p passw0rd
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    foo
  * support

Using project "support".
[abc@foo 18:03:08 - q5]$oc new-project test
Now using project "test" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname
```




# Part 2


```
$oc  whoami
abc

$oc adm groups new ex280-viewers
group.user.openshift.io/ex280-viewers created

$oc adm groups add-users ex280-viewers linda
group.user.openshift.io/ex280-viewers added: "linda"

$oc get clusterroles | grep ^view
view                                                                        2021-11-25T03:57:16Z

# make sure it is cluster role not add-role-to-group. add-role-to-group is just to the project not cluster wide.

$oc adm policy add-cluster-role-to-group view ex280-viewers
clusterrole.rbac.authorization.k8s.io/view added: "ex280-viewers"


```

Login as user linda and view pods in all namespaces

```
$oc login -u abc -p passw0rd
Login successful.
$oc get pods -A | wc -l
69

```


# remove user linda from ex280-viewers and check if it err

```
$oc login -u abc -p passw0rd
Login successful.

You have access to 67 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "test".
$oc adm policy remove-cluster-role-from-group view ex280-viewers
clusterrole.rbac.authorization.k8s.io/view removed: "ex280-viewers"
$oc login -u linda -p passw0rd
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    foo
    support
  * test

Using project "test".
$oc get pods -A | wc -l
Error from server (Forbidden): pods is forbidden: User "linda" cannot list resource "pods" in API group "" at the cluster scope
0
```

# Part 3

```
$oc adm groups new qa-group
group.user.openshift.io/qa-group created
$oc adm groups new uat-group
group.user.openshift.io/uat-group created
$oc adm groups new support-group
group.user.openshift.io/support-group created
$oc adm groups add-users qa-group joe
group.user.openshift.io/qa-group added: "joe"
$oc adm groups add-users support-group jill
group.user.openshift.io/support-group added: "jill"
$oc adm groups add-users uat-group raj
group.user.openshift.io/uat-group added: "raj"
$oc adm policy add-cluster-role-to-group view qa-group
clusterrole.rbac.authorization.k8s.io/view added: "qa-group"
$oc adm policy add-cluster-role-to-group  edit support-group
clusterrole.rbac.authorization.k8s.io/edit added: "support-group"
$oc adm policy add-cluster-role-to-group basic-user uat-group
clusterrole.rbac.authorization.k8s.io/basic-user added: "uat-group"

$oc get clusterrolebindings -o wide | egrep 'NAME|group' |  tr -s [:space:]
NAME ROLE AGE USERS GROUPS SERVICEACCOUNTS
basic-user ClusterRole/basic-user 8m7s uat-group 
edit ClusterRole/edit 5m55s support-group 
view ClusterRole/view 6m20s qa-group
```
