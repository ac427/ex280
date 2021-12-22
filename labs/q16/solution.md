```
$oc login -u kubeadmin -p bMQh7-zfaiL-ghEDw-zNRui https://api.crc.testing:6443
$oc label nodes crc-x4qnm-master-0 tier=gold
$oc create quota review-quota -n schedule-review --hard=cpu=1,memory=2G,pods=20
resourcequota/review-quota created


$oc login -u developer -p developer https://api.crc.testing:6443
Login successful.
$oc new-project schedule-review
$oc new-app --name loadtest --image quay.io/redhattraining/loadtest:v1.0 
--> Found container image 545296d (2 years old) from quay.io for "quay.io/redhattraining/loadtest:v1.0"

    Python 2.7 
    ---------- 
    Python 2.7 available as container is a base platform for building and running various Python 2.7 applications and frameworks. Python is an easy to learn, powerful programming language. It has efficient high-level data structures and a simple but effective approach to object-oriented programming. Python's elegant syntax and dynamic typing, together with its interpreted nature, make it an ideal language for scripting and rapid application development in many areas on most platforms.

    Tags: builder, python, python27, python-27, rh-python27

    * An image stream tag will be created as "loadtest:v1.0" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "loadtest" created
    deployment.apps "loadtest" created
    service "loadtest" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/loadtest' 
    Run 'oc status' to view your app.

$oc edit deployment/loadtest. update below under spec.template.spec
```
      nodeSelector:
        tier: gold
```
$oc set resources deployment/loadtest  --requests=cpu=100m,memory=20Mi
deployment.apps/loadtest resource requirements updated

$oc get svc
NAME       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
loadtest   ClusterIP   10.217.5.182   <none>        8080/TCP   87s

$oc expose service loadtest
route.route.openshift.io/loadtest exposed

$oc get route
NAME       HOST/PORT                                   PATH   SERVICES   PORT       TERMINATION   WILDCARD
loadtest   loadtest-schedule-review.apps-crc.testing          loadtest   8080-tcp                 None


$curl http://loadtest-schedule-review.apps-crc.testing/api/loadtest/v1/healthz
{"health":"ok"}

$oc autoscale deployment/loadtest --min=2 --max=40 --cpu-percent=70
horizontalpodautoscaler.autoscaling/loadtest autoscaled


$curl -X GET http://loadtest-schedule-review.apps-crc.testing/api/loadtest/v1/cpu/3


$oc logs loadtest-749cc9bdf-bqnkp
---> Running application from Python script (app.py) ...
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: Do not use the development server in a production environment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
10.217.0.1 - - [21/Dec/2021 03:19:32] "GET /api/loadtest/v1/healthz HTTP/1.1" 200 -
Number of cpus available: 4
--------------------
Running load on CPU(s)
Utilizing 3 cores
--------------------
10.217.0.1 - - [21/Dec/2021 03:24:11] "GET /api/loadtest/v1/cpu/3 HTTP/1.1" 200 -

# it can take upto 5 min for the unknown to change. It proabably requires metering-api enabled on crc too.

$oc get hpa
NAME       REFERENCE             TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
loadtest   Deployment/loadtest   <unknown>/70%   2         40        2          15m



# You can save the running deployment and update `type=silver` in deployment.yaml

```
$oc get deployment loadtest  -o yaml > deployment.yaml
$oc delete deployment loadtest
deployment.apps "loadtest" deleted
$oc apply -f deployment.yaml 
deployment.apps/loadtest created
$oc get pods
NAME                        READY   STATUS    RESTARTS   AGE
loadtest-666c5cf5b6-bsmlm   0/1     Pending   0          3m26s
loadtest-666c5cf5b6-dbtgf   0/1     Pending   0          3m26s

$oc describe pod loadtest-666c5cf5b6-bsmlm | grep -i warning
  Warning  FailedScheduling  13s (x2 over 88s)  default-scheduler  0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector.

```

You can see the pods are in pending state as there are no nodes with label type=silver

You can update the deployment to have type=gold and see the pods getting run on our single node cluster :)


```

[abc@foo 22:30:08 - q16]$oc edit deployment loadtest
deployment.apps/loadtest edited
[abc@foo 22:31:03 - q16]$oc get pods
NAME                        READY   STATUS    RESTARTS   AGE
loadtest-666c5cf5b6-dbtgf   0/1     Pending   0          4m24s
loadtest-749cc9bdf-997fs    0/1     Pending   0          1s
loadtest-749cc9bdf-qt5tj    1/1     Running   0          3s
[abc@foo 22:31:06 - q16]$oc get pods
NAME                        READY   STATUS              RESTARTS   AGE
loadtest-666c5cf5b6-dbtgf   0/1     Pending             0          4m27s
loadtest-749cc9bdf-997fs    0/1     ContainerCreating   0          4s
loadtest-749cc9bdf-qt5tj    1/1     Running             0          6s
[abc@foo 22:31:09 - q16]$oc get pods
NAME                       READY   STATUS    RESTARTS   AGE
loadtest-749cc9bdf-997fs   1/1     Running   0          6s
loadtest-749cc9bdf-qt5tj   1/1     Running   0          8s
```
