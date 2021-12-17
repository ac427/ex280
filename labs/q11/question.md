* As regular user

- create new-project wordpress
- create secret wp-secret with values user=wpuser,password=redhat123, and database=wordpress
- deploy app mysql using image registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7-47 and use secrets from wp-secret. prefix MYSQL_ to env
- deploy wordpress using image docker.io/library/wordpress:5.3.0.  set env WORDPRESS_DB_HOST=mysql and WORDPRESS_DB_NAME=wordpress environment
When creating the application, add use values from secret wp-secret as additional env and  prefix with  WORDPRESS_DB_ 

* As the admin user

- identify a less restrictive SCC that allows the wordpress deployment

* as regular user

- modify the deployment and expose the route and verify the app
