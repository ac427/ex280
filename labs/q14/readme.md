# Task 1

- create project net-1 and net-2
- create deployment bnginx --image=bitnami/nginx in net2
- create a network policy to allow connections only from net-1 to net-2 to port 8080

# Task 2

- create a network policy to allow connections only from pods with label "app=client" from namespace label ns=client

