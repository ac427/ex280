# Fix for the lab in 04c-Configure_networking_components.md

```
$oc get pods --show-labels 
NAME      READY   STATUS    RESTARTS   AGE     LABELS
client1   1/1     Running   0          9m46s   <none>
client2   1/1     Running   0          9m46s   allow=true
$oc label pod client2 access="allow"
pod/client2 labeled
$oc rsh client2
/ # wget --spider 10.217.5.183:8080 --timeout 1
Connecting to 10.217.5.183:8080 (10.217.5.183:8080)
remote file exists
/ # 
```

# Troubleshooting Network connection

from `oc debug -h`

```
Examples:
  # Start a shell session into a pod using the OpenShift tools image
  oc debug
  
  # Debug a currently running deployment by creating a new pod
  oc debug deploy/test
  
  # Debug a node as an administrator
  oc debug node/master-1
  
  # Launch a shell in a pod using the provided image stream tag
  oc debug istag/mysql:latest -n openshift
  
  # Test running a job as a non-root user
  oc debug job/test --as-user=1000000
  
  # Debug a specific failing container by running the env command in the 'second' container
  oc debug daemonset/test -c second -- /bin/env
  
  # See the pod that would be created to debug
  oc debug mypod-9xbc -o yaml
  
  # Debug a resource but launch the debug pod in another namespace
  # Note: Not all resources can be debugged using --to-namespace without modification. For example,
  # volumes and service accounts are namespace-dependent. Add '-o yaml' to output the debug pod definition
  # to disk.  If necessary, edit the definition then run 'oc debug -f -' or run without --to-namespace
  oc debug mypod-9xbc --to-namespace testns
```

