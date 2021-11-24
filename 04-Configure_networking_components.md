# Configure networking components

https://docs.openshift.com/container-platform/4.9/networking/understanding-networking.html


#### Viewing Cluster Network Config

```
$ oc describe network.config/cluster
```

#### View status of Network Operator

```
$ oc describe clusteroperators/network
```


#### Viewing Cluster Network Operator logs

```
$ oc logs --namespace=openshift-network-operator deployment/network-operator

```

# DNS Operator in OpenShift Container Platform

The DNS Operator implements the dns API from the operator.openshift.io API group. The Operator deploys CoreDNS using a daemon set, creates a service for the daemon set, and configures the kubelet to instruct pods to use the CoreDNS service IP address for name resolution.

```
$ oc get -n openshift-dns-operator deployment/dns-operator

$ oc get clusteroperator/dns

$ oc describe dns.operator/default

$ oc edit dns.operator/default

$ oc get configmap/dns-default -n openshift-dns -o yaml

$ oc logs -n openshift-dns-operator deployment/dns-operator -c dns-operator

```


# Lab: Create edge route

```
# create a new project
oc new-project netlab
# create new deployment
oc new-app --name bnginx --image bitnami/nginx
# Generate self signed cert. hostname bnginx-netlab.apps-crc.testing

$./cert_generator.sh bnginx-netlab.apps-crc.testing
creating CA
Generating RSA private key, 4096 bit long modulus (2 primes)
...................................++++
...............................................................................................................++++
e is 65537 (0x010001)
generating key for the doamin $1
Generating RSA private key, 2048 bit long modulus (2 primes)
.................+++++
..........+++++
e is 65537 (0x010001)
creating csr
signing the cert using the CA credentials
Signature ok
subject=C = US, ST = CA, O = "MyOrg, Inc.", CN = bnginx-netlab.apps-crc.testing
Getting CA Private Key

$ls openssl/
bnginx-netlab.apps-crc.testing.crt  bnginx-netlab.apps-crc.testing.csr  bnginx-netlab.apps-crc.testing.key  rootCA.crt  rootCA.key  rootCA.srl

$oc create route edge --service=bnginx --cert=./openssl/bnginx-netlab.apps-crc.testing.crt --key=./openssl/bnginx-netlab.apps-crc.testing.key --ca-cert=./openssl/rootCA.crt --port 8080 --hostname=bgninx-netlab.apps-crc.testing

## wola!
$oc get route
NAME     HOST/PORT                        PATH   SERVICES   PORT   TERMINATION   WILDCARD
bnginx   bgninx-netlab.apps-crc.testing          bnginx     8080   edge          None
$
$
$curl https://bgninx-netlab.apps-crc.testing
curl: (60) SSL certificate problem: self signed certificate in certificate chain
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
$curl --insecure https://bgninx-netlab.apps-crc.testing
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```

#### Verify it is using the selfsigned cert

```
$ echo quit | openssl s_client -showcerts -servername bgninx-netlab.apps-crc.testing -connect bgninx-netlab.apps-crc.testing:443| grep issuer
depth=1 C = US, ST = CA, O = "MyOrg, Inc.", CN = crc.example.com
verify error:num=19:self signed certificate in certificate chain
verify return:1
depth=1 C = US, ST = CA, O = "MyOrg, Inc.", CN = crc.example.com
verify return:1
depth=0 C = US, ST = CA, O = "MyOrg, Inc.", CN = bnginx-netlab.apps-crc.testing
verify return:1
DONE
issuer=C = US, ST = CA, O = "MyOrg, Inc.", CN = crc.example.com
```
# Passthrough route

```
# create config file with below command
$oc new-app --name=bnginx --dry-run --image=bitnami/nginx -o yaml > pass.yaml
# Now update pass.yaml with volumeMounts and volumes. check pass.yaml in the repo

$oc create secret tls bnginx-ssl --cert=./openssl/bnginx-netlab.apps-crc.testing.crt --key=./openssl/bnginx-netlab.apps-crc.testing.key 
secret/bnginx-ssl created
$oc create cm bnginx-config --from-file ./bnginx.conf
$oc apply  -f pass.yaml 
deployment.apps/bnginx configured
service/bnginx configured
$oc get pods
NAME                    READY   STATUS    RESTARTS   AGE
bnginx-fcdfb557-wlkzg   1/1     Running   0          4s
$oc create route passthrough bnginx --service=bnginx --port=8443 --hostname=bnginx-netlab.apps-crc.testing
route.route.openshift.io/bnginx created
$oc get svc
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
bnginx   ClusterIP   10.217.4.137   <none>        8080/TCP,8443/TCP   2m49s
$oc get routes
NAME     HOST/PORT                        PATH   SERVICES   PORT   TERMINATION   WILDCARD
bnginx   bnginx-netlab.apps-crc.testing          bnginx     8443   passthrough   None

#### Verification: Run a debug pod to test https connection
```
$oc debug -t deployment/bnginx --image=alpine/openssl
Starting pod/bnginx-debug ...
Pod IP: 10.217.0.119
If you don't see a command prompt, try pressing enter.
/ # echo quit | openssl s_client -showcerts -servername bnginx-netlab.apps-crc.testing -connect bnginx-netlab.apps-crc.testing:443 | grep bnginx
depth=0 C = US, ST = CA, O = "MyOrg, Inc.", CN = bnginx-netlab.apps-crc.testing
verify error:num=20:unable to get local issuer certificate
verify return:1
depth=0 C = US, ST = CA, O = "MyOrg, Inc.", CN = bnginx-netlab.apps-crc.testing
verify error:num=21:unable to verify the first certificate
verify return:1
DONE
 0 s:C = US, ST = CA, O = "MyOrg, Inc.", CN = bnginx-netlab.apps-crc.testing
subject=C = US, ST = CA, O = "MyOrg, Inc.", CN = bnginx-netlab.apps-crc.testing
/ # 
Removing debug pod ...
$oc debug -t deployment/bnginx --image=curlimages/curl
Starting pod/bnginx-debug ...
Pod IP: 10.217.0.120
If you don't see a command prompt, try pressing enter.

/ $ curl --insecure https://10.217.5.194:8443
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```
