1. As the admin user, label two nodes with the tier label. Give the master01 node the label
of tier=gold and the master02 node the label of tier=silver.
                or
just label the node to tier=gold if you are on one node cluster ( crc )

2. Switch to the developer user and create a new project named schedule-review.

3. Create a new application named loadtest using the container image located at quay.io/
redhattraining/loadtest:v1.0. The loadtest application should be deployed to
nodes labeled with tier=gold. Ensure that each container requests 100m of CPU and
20Mi of memory.

4. Create a route to your application named loadtest using the default (automatically
generated) host name. Depending on how you created your application, you might need
to create a service before creating the route. Your application works as expected if running
`curl http://loadtest-schedule-review.apps.ocp4.example.com/api/loadtest/v1/healthz` returns {"health":"ok"}.

5. Create a horizontal pod autoscaler named loadtest for the loadtest application that
will scale from 2 pods to a maximum of 40 pods if CPU load exceeds 70%. You can test the
horizontal pod autoscaler with the following command: curl -X GET http://loadtest-
schedule-review.apps.ocp4.example.com/api/loadtest/v1/cpu/3

Note
Although the horizontal pod autoscaler will scale the loadtest application, your
OpenShift cluster will run out of resources before it reaches a maximum of 40 pods.
As the admin user, implement a quota named review-quota on the schedule-review
project. Limit the schedule-review project to a maximum of 1 full CPU, 2G of memory,
and 20 pods.
