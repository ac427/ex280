# Projects

 -   Allows groups of users or developers to work together
 -   Unit of isolation and collaboration
 -    Defines scope of resources
 -    Allows project administrators and collaborators to manage resources
 -    Restricts and tracks use of resources with quotas and limits
 -    Kubernetes namespace with additional annotations
 -    Central vehicle for managing resource access for regular users
 -    Lets community of users organize and manage content in isolation from other communities
 - Each project has own:

   -  Objects: Pods, services, replication controllers, etc.
   -  Policies: Rules that specify which users can or cannot perform actions on objects
   -  Constraints: Quotas for objects that can be limited
   -  Service accounts: Users that act automatically with access to project objects

### Create and delete projects

```
$oc new-project my-website
Now using project "my-website" on server "https://api.crc.testing:6443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app rails-postgresql-example

to build a new example application in Ruby. Or use kubectl to deploy a simple Kubernetes application:

    kubectl create deployment hello-node --image=k8s.gcr.io/serve_hostname

$oc delete project my-website
project.project.openshift.io "my-website" deleted

```

### Create new app
```
$ oc new-app --docker-image=bitnami/nginx --name=bnginx
--> Found container image 413cc0f (25 hours old) from Docker Hub for "bitnami/nginx"

    * An image stream tag will be created as "bnginx:latest" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "bnginx" created
    deployment.apps "bnginx" created
    service "bnginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/bnginx'
    Run 'oc status' to view your app.
```
###### There are no option to delete all resources created with new-app. You have to delete one by one by running

```
oc delete deployment/bnginx
oc delete imagestream.image.openshift.io/bnginx
oc delete service/bnginx

```

### Create deployment from source to image (S2I)

```
$oc new-app https://github.com/ac427/bottle
--> Found container image eeb6ee3 (2 months old) from Docker Hub for "centos:7"

    * An image stream tag will be created as "centos:7" that will track the source image
    * A Docker build using source code from https://github.com/ac427/bottle will be created
      * The resulting image will be pushed to image stream tag "bottle:latest"
      * Every time "centos:7" changes a new build will be triggered

--> Creating resources ...
    imagestream.image.openshift.io "centos" created
    imagestream.image.openshift.io "bottle" created
    buildconfig.build.openshift.io "bottle" created
    deployment.apps "bottle" created
    service "bottle" created
--> Success
    Build scheduled, use 'oc logs -f buildconfig/bottle' to track its progress.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/bottle' 
    Run 'oc status' to view your app.
```

### create a new app with deploymentconfig. DeploymentConfig is a openshift resource (depricated in kubernetes)

```
$oc new-app --as-deployment-config --name=bnginx --image=bitnami/nginx
--> Found container image e3d007c (14 hours old) from Docker Hub for "bitnami/nginx"

    * An image stream tag will be created as "bnginx:latest" that will track this image
    * This image will be deployed in deployment config "bnginx"
    * Ports 8080/tcp, 8443/tcp will be load balanced by service "bnginx"
      * Other containers can access this service through the hostname "bnginx"

--> Creating resources ...
    imagestream.image.openshift.io "bnginx" created
    deploymentconfig.apps.openshift.io "bnginx" created
    service "bnginx" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/bnginx' 
    Run 'oc status' to view your app.
```


###  Examine resources and cluster status

```
oc get nodes
oc adm top nodes
oc describe node $node-name
oc get clusterversion
oc describe clusterversion
oc get clusteroperators
oc get pods
oc api-resources
oc api-versions
oc explain Pod
oc explain Pod.spec
oc status
```

###  View logs
`oc logs $pod-name (-n namespace)`

### - Monitor cluster events and alerts

```
oc get events
oc describe pod $podname
oc status

```
###  Troubleshoot common cluster events and alerts
```
oc describe pod $podname
oc adm node-logs -u $user $node-name
oc debug node/$node-name
oc rsh $pod-name
oc cp $filename $pod-name:/$path
```

# GUI - Resource Exploration [Lab](https://cloud.scorm.com/vault/8751c1a1-e481-4e39-b374-640261ebcb43/content/courses/A9KI96X2QE/7258c7145e5b/20/03_OpenShift_User_Experience/03_01_Demonstrate_OpenShift_Resources_Lab.html#_demonstrate_the_developer_perspective) 

[Local copy html](https://htmlpreview.github.io/?https://github.com/ac427/ex-280/blob/main/docs/Resources_Lab.html)

[Local copy pdf](https://github.com/ac427/ex-280/blob/main/docs/Resource%20Exploration%20Lab.pdf)
