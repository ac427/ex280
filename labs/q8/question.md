create new project secrets-
create a new deployment with image registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7-47
create secret/mysql from env file env_vars
update deployment mysql with env from secret/mysql and prefix MYSQL
test the sql connection by logging into pod and running 

```
mysql -u myuser --password=redhat123 test_secrets -e 'show databases;'
```

create deployment with image quay.io/redhattraining/famous-quotes
fix the deployment using secrets/quotes and prefix QUOTES_
verify the logs to see a successful connection 
expose quotes service to access outside the cluster and run curl on the end point
