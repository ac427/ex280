
```
$oc create deployment bdb --image bitnami/mariadb
deployment.apps/bdb created

$oc get pods
NAME                 READY   STATUS              RESTARTS   AGE
bdb-66c869cf-nblgw   0/1     Error               0          32s

$oc logbdb-66c869cf-nblgwgw
mariadb 14:26:55.23 
mariadb 14:26:55.24 Welcome to the Bitnami mariadb container
mariadb 14:26:55.25 Subscribe to project updates by watching https://github.com/bitnami/bitnami-docker-mariadb
mariadb 14:26:55.25 Submit issues and feature requests at https://github.com/bitnami/bitnami-docker-mariadb/issues
mariadb 14:26:55.26 
mariadb 14:26:55.26 INFO  ==> ** Starting MariaDB setup **
mariadb 14:26:55.39 INFO  ==> Validating settings in MYSQL_*/MARIADB_* env vars
mariadb 14:26:55.50 ERROR ==> The MARIADB_ROOT_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development.


$oc create secret generic mdb --from-literal MARIADB_ROOT_PASSWORD=passw0rd
secret/mdb created

$oc set env --from=secret/mdb deployment/bdb
deployment.apps/bdb updated

$oc get pods
NAME                  READY   STATUS    RESTARTS   AGE
bdb-6c97f7d5c-qczh8   1/1     Running   0          78s



#q2

```
$oc new-app  --image=bitnami/nginx
--> Found container image 4173d05 (21 hours old) from Docker Hub for "bitnami/nginx"

    * An image stream tag will be created as "nginx:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "nginx" created
    deployment.apps "nginx" created
    service "nginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/nginx' 
    Run 'oc status' to view your app.
$oc create secret generic top-secret --from-literal account=123456 --from-literal password=top-secret
secret/top-secret created
$oc set volumes deployment/nginx --add --type secret --secret-name top-secret -m /tmp/data
info: Generated volume name: volume-wwqcs
deployment.apps/nginx volume updated
```
