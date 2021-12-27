[abc@foo 13:10:16 - q19]$kubectl create deployment bnginx --image bitnami/nginx
deployment.apps/bnginx created
[abc@foo 13:10:37 - q19]$kubectl get pods
NAME                      READY   STATUS              RESTARTS   AGE
bnginx-7c9f484f5c-9qnkl   0/1     ContainerCreating   0          5s
[abc@foo 13:10:42 - q19]$kubectl autoscale deployment bnginx --max=5 --min=2 --cpu-percent=50
horizontalpodautoscaler.autoscaling/bnginx autoscaled
[abc@foo 13:10:53 - q19]$kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-7c9f484f5c-9qnkl   1/1     Running   0          17s
[abc@foo 13:10:58 - q19]$kubectl get deployment
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
bnginx   1/1     1            1           30s
[abc@foo 13:11:07 - q19]$kubectl get hpa
NAME     REFERENCE           TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
bnginx   Deployment/bnginx   <unknown>/50%   2         5         1          25s
[abc@foo 13:11:19 - q19]$kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
bnginx-7c9f484f5c-9qnkl   1/1     Running   0          63s
bnginx-7c9f484f5c-d25l6   1/1     Running   0          32s

