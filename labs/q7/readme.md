q1
- create deployment bdb with image bitnami/mariadb
- see the reason of failing
- fix it

q2
- create a secret top-secret and add below values
account=123456
password=top-secret
- create a deployment with  container with image bitnami/nginx and mount /tmp/data with values from secret/top-secret
