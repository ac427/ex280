$oc new-project database
$oc new-app --name mysql --image registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7-47
--> Found container image 77d20f2 (2 years old) from registry.access.redhat.com for "registry.access.redhat.com/rhscl/mysql-57-rhel7:5.7-47"

    MySQL 5.7 
    --------- 
    MySQL is a multi-user, multi-threaded SQL database server. The container image provides a containerized packaging of the MySQL mysqld daemon and client application. The mysqld server daemon accepts connections from clients and provides access to content from MySQL databases on behalf of the clients.

    Tags: database, mysql, mysql57, rh-mysql57

    * An image stream tag will be created as "mysql:5.7-47" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "mysql" created
    deployment.apps "mysql" created
    service "mysql" created
--> Success
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/mysql' 
    Run 'oc status' to view your app.
$oc create secret generic mysql --from-env-file env_vars 
secret/mysql created
$oc set env deployment/mysql --from secret/mysql --prefix MYSQL_ 
deployment.apps/mysql updated

$oc get pods
NAME                     READY   STATUS    RESTARTS   AGE
mysql-5675d67f97-2z649   1/1     Running   0          12s
$oc rsh mysql-5675d67f97-2z649
sh-4.2$ mysql -u myuser --password=redhat123 test_secrets -e 'show databases;'
mysql: [Warning] Using a password on the command line interface can be insecure.
+--------------------+
| Database           |
+--------------------+
| information_schema |
| test_secrets       |
+--------------------+


$oc new-app --name quotes --image quay.io/redhattraining/famous-quotes

$oc set env deployment/quotes --from secrets/mysql --prefix QUOTES_
deployment.apps/quotes updated
$oc get pods
NAME                      READY   STATUS        RESTARTS   AGE
mysql-5675d67f97-2z649    1/1     Running       0          3m41s
quotes-59999c4b46-kzkgb   0/1     Terminating   3          89s
quotes-6b79597dc5-kmgt8   1/1     Running       0          5s
$oc logs quotes-77df54758b-mqdtf | head 
Error from server (NotFound): pods "quotes-77df54758b-mqdtf" not found
$oc logs quotes-6b79597dc5-kmgt8 | head
2021/12/15 15:35:04 Connecting to the database: myuser:redhat123@tcp(mysql:3306)/test_secrets
2021/12/15 15:35:04 Database connection OK
2021/12/15 15:35:04 Creating schema
2021/12/15 15:35:04 Adding quotes
2021/12/15 15:35:04 Adding quote: When words fail, music speaks.
- William Shakespeare
2021/12/15 15:35:04 Adding quote: Happiness depends upon ourselves.
- Aristotle
2021/12/15 15:35:04 Adding quote: The secret of change is to focus all your energy not on fighting the old but on building the new.
- Socrates

$oc get services
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
mysql    ClusterIP   10.217.5.104   <none>        3306/TCP   10m
quotes   ClusterIP   10.217.5.131   <none>        8000/TCP   4m44s
$oc expose service quotes
route.route.openshift.io/quotes exposed
$oc get services
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
mysql    ClusterIP   10.217.5.104   <none>        3306/TCP   10m
quotes   ClusterIP   10.217.5.131   <none>        8000/TCP   4m53s
$oc get routes
NAME     HOST/PORT                              PATH   SERVICES   PORT       TERMINATION   WILDCARD
quotes   quotes-database.apps-crc.testing          quotes     8000-tcp                 None
$curl http://quotes-database.apps-crc.testing
<html>
	<head>
        <title>Quotes</title>
    </head>
    <body>
       
        <h1>Quote List</h1>
        
            <ul>
                
                    <li>1: When words fail, music speaks.
- William Shakespeare
</li>
                
                    <li>2: Happiness depends upon ourselves.
- Aristotle
</li>
                
                    <li>3: The secret of change is to focus all your energy not on fighting the old but on building the new.
- Socrates
</li>
                
                    <li>4: Nothing that glitters is gold.
- Mark Twain</li>
                
                    <li>5: Imagination is more important than knowledge.
- Albert Einstein
</li>
                
                    <li>6: Hell, if I could explain it to the average person, it wouldn&#39;t have been worth the Nobel prize.
- Richard Feynman
</li>
                
                    <li>7: Young man, in mathematics you don&#39;t understand things. You just get used to them.
- John von Neumann
</li>
                
                    <li>8: Those who can imagine anything, can create the impossible.
- Alan Turing
</li>
                
            </ul>
        
    </body>
</html>


$curl http://quotes-database.apps-crc.testing/random
8: Those who can imagine anything, can create the impossible.
- Alan Turing
$curl http://quotes-database.apps-crc.testing/status
Database connection OK
