```
$oc create role  dbas --verb=get,list,watch --resource=pods,secrets,configmaps,services -n database
role.rbac.authorization.k8s.io/dbas created
$oc create rolebinding dbas --role=dbas -n database
rolebinding.rbac.authorization.k8s.io/dbas created
$oc adm policy add-role-to-user --role-namespace=database --rolebinding-name dbas dbas lee
role.rbac.authorization.k8s.io/dbas added: "lee"
```

* verify

```

$oc login -u lee -p passw0rd
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

  * testing1
    testing5

Using project "testing1".
$oc get pods -n database
NAME                      READY   STATUS    RESTARTS   AGE
mysql-d6cbdffb5-r7mf2     1/1     Running   0          46m
quotes-654c588475-gngrt   1/1     Running   0          43m
```
* get routes is failing as we did not give access to routes resource

``
$oc get routes -n database
Error from server (Forbidden): routes.route.openshift.io is forbidden: User "lee" cannot list resource "routes" in API group "route.openshift.io" in the namespace "database"
```


* robin has no access to database ns

```
$oc login -u robin -p passw0rd
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

  * testing
    testing3

Using project "testing".
$oc get pods -n database
Error from server (Forbidden): pods is forbidden: User "robin" cannot list resource "pods" in API group "" in the namespace "database"
$
```
