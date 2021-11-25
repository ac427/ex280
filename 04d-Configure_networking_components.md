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

