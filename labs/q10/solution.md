
```
$oc whoami
abc

$oc new-project my-nginx
Now using project "my-nginx" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

$oc new-app --name mynginx --image nginx
--> Found container image f652ca3 (2 weeks old) from Docker Hub for "nginx"

    * An image stream tag will be created as "mynginx:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "mynginx" created
    deployment.apps "mynginx" created
    service "mynginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/mynginx' 
    Run 'oc status' to view your app.

$oc get pods
NAME                       READY   STATUS             RESTARTS     AGE
mynginx-6c88757dd7-vzj8r   0/1     CrashLoopBackOff   1 (3s ago)   7s

$oc logs mynginx-6c88757dd7-vzj8r 
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: can not modify /etc/nginx/conf.d/default.conf (read-only file system?)
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2021/12/15 19:06:33 [warn] 1#1: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:2
2021/12/15 19:06:33 [emerg] 1#1: mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)
nginx: [emerg] mkdir() "/var/cache/nginx/client_temp" failed (13: Permission denied)

$oc get pod mynginx-6c88757dd7-vzj8r -o yaml | oc adm policy scc-subject-review -f - 
RESOURCE                       ALLOWED BY   
Pod/mynginx-6c88757dd7-vzj8r   anyuid       


$oc create serviceaccount mynginx
serviceaccount/mynginx created

$oc adm policy add-scc-to-user anyuid -z mynginx
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:anyuid added: "mynginx"

$oc set serviceaccount deployment/mynginx mynginx
deployment.apps/mynginx serviceaccount updated

$oc get pods
NAME                       READY   STATUS              RESTARTS      AGE
mynginx-6c88757dd7-vzj8r   0/1     CrashLoopBackOff    4 (57s ago)   2m35s
mynginx-75f5877865-xcfrx   0/1     ContainerCreating   0             2s
$oc get pods
NAME                       READY   STATUS    RESTARTS   AGE
mynginx-75f5877865-xcfrx   1/1     Running   0          6s
```
