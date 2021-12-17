$oc create role  dbas --verb=get,list,watch --resource=pods,secrets,configmaps,services -n database
role.rbac.authorization.k8s.io/dbas created
$oc create rolebinding dbas --role=dbas --group system:authenticated:oauth
rolebinding.rbac.authorization.k8s.io/dbas created
$oc adm policy add-role-to-user dbas lee
clusterrole.rbac.authorization.k8s.io/dbas added: "lee"
$oc login -u lee -p passw0rd
Login successful.

You have access to the following projects and can switch between them with 'oc project <projectname>':

  * testing1
    testing5

Using project "testing1".
$oc get pods -n database
NAME                      READY   STATUS    RESTARTS   AGE
mysql-d6cbdffb5-r7mf2     1/1     Running   0          14m
quotes-654c588475-gngrt   1/1     Running   0          11m
$oc get routes -n database
Error from server (Forbidden): routes.route.openshift.io is forbidden: User "lee" cannot list resource "routes" in API group "route.openshift.io" in the namespace "database": RBAC: clusterrole.rbac.authorization.k8s.io "dbas" not found
