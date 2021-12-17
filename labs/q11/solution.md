```
$oc new-project wordpress
Now using project "wordpress" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

$oc create secret generic wp-secret --from-literal user=wpuser --from-literal password=redhat123 --from-literal database=wordpress
secret/wp-secret created

$oc new-app --name mysql --image registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7-47 
--> Found container image 77d20f2 (2 years old) from registry.access.redhat.com for "registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7-47"

    MySQL 5.7 
    --------- 
    MySQL is a multi-user, multi-threaded SQL database server. The container image provides a containerized packaging of the MySQL mysqld daemon and client application. The mysqld server daemon accepts connections from clients and provides access to content from MySQL databases on behalf of the clients.

    Tags: database, mysql, mysql57, rh-mysql57

    * An image stream tag will be created as "mysql:5.7-47" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "mysql" created
    deployment.apps "mysql" created
    service "mysql" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/mysql' 
    Run 'oc status' to view your app.

$oc set env --from secret/wp-secret deployment/mysql --prefix MYSQL_
deployment.apps/mysql updated


$oc new-app --name wordpress --image docker.io/library/wordpress:5.3.0 --env WORDPRESS_DB_HOST=mysql --env WORDPRESS_DB_NAME=wordpress
--> Found container image ee025cb (2 years old) from docker.io for "docker.io/library/wordpress:5.3.0"

    * An image stream tag will be created as "wordpress:5.3.0" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "wordpress" created
    deployment.apps "wordpress" created
    service "wordpress" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/wordpress' 
    Run 'oc status' to view your app.

$oc set env --from secret/wp-secret deployment/wordpress --prefix WORDPRESS_DB_
deployment.apps/wordpress updated

$oc get pods
NAME                        READY   STATUS             RESTARTS      AGE
mysql-7c4ff87494-bknr7      1/1     Running            0             14m
wordpress-dd6d7556d-v8h9w   0/1     CrashLoopBackOff   6 (90s ago)   7m23s
$oc get pod wordpress-dd6d7556d-v8h9w -o yaml | oc adm policy scc-subject-review -f -
RESOURCE                        ALLOWED BY   
Pod/wordpress-dd6d7556d-v8h9w   anyuid   

$oc create serviceaccount wp-sa
serviceaccount/wp-sa created


$oc adm policy add-scc-to-user restricted -z wp-sa 
Error from server (Forbidden): clusterrolebindings.rbac.authorization.k8s.io "system:openshift:scc:restricted" is forbidden: User "lee" cannot get resource "clusterrolebindings" in API group "rbac.authorization.k8s.io" at the cluster scope
```

# as Admin user

```
$oc login -u abc -p passw0rd
Login successful.

You have access to 76 projects, the list has been suppressed. You can list all projects with 'oc projects'

Using project "wordpress".
$oc adm policy add-scc-to-user anyuid -z wp-sa
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:anyuid added: "wp-sa"
```

# Back to basic user lee

```
$oc set serviceaccount deployment/wordpress wp-sa
deployment.apps/wordpress serviceaccount updated

$oc get pods
NAME                         READY   STATUS    RESTARTS   AGE
mysql-7c4ff87494-bknr7       1/1     Running   0          15m
wordpress-6498c7fb86-xt27d   1/1     Running   0          7s

$oc get services
NAME        TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
mysql       ClusterIP   10.217.4.90    <none>        3306/TCP   9m9s
wordpress   ClusterIP   10.217.5.240   <none>        80/TCP     5m11s

$oc expose service wordpress
route.route.openshift.io/wordpress exposed

$oc get route
NAME        HOST/PORT                              PATH   SERVICES    PORT     TERMINATION   WILDCARD
wordpress   wordpress-wordpress.apps-crc.testing          wordpress   80-tcp                 None

```

open http://wordpress-wordpress.apps-crc.testing in a browser or `curl -L wordpress-wordpress.apps-crc.testing`
