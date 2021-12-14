# Storage

two pods sharing an empty dir. the data in the dir will be available until the end of the pod life.

In below deployment we are running second container sleep2 only for 30 sec. You can see the data still available after pod getting killed.
If both the pods die then the data gets destroyed.

```
cat volume-empty-dir.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: empty-dir
spec:
  containers:
    - name: sleep1
      command:
        - sleep
        - infinity
      image: busybox
      volumeMounts:
        - name: test
          mountPath: /data

    - name: sleep2
      command:
        - sleep
        - '30'
      image: busybox
      volumeMounts:
        - name: test
          mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
    - name: test
      emptyDir: {}
$oc apply -f volume-empty-dir.yaml 
pod/empty-dir created
$oc get pods
NAME        READY   STATUS              RESTARTS   AGE
empty-dir   0/2     ContainerCreating   0          4s
$oc exec -it empty-dir -c sleep1 -- sh
/ # echo foo > /data/qux
/ # 
$oc exec -it empty-dir -c sleep2 -- sh
/ # cat command terminated with exit code 137
$oc exec -it empty-dir -c sleep2 -- sh
/ # cat /data/qux
foo
/ # echo qux >> /data/qux
/ # command terminated with exit code 137
$oc exec -it empty-dir -c sleep1 -- sh
/ # cat /data/qux
foo
qux
```
