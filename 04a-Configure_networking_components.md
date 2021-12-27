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

$./scripts/cert_generator.sh bnginx-netlab.apps-crc.testing
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

$ls bnginx-netlab.apps-crc.testing/
bnginx-netlab.apps-crc.testing.crt  bnginx-netlab.apps-crc.testing.csr  bnginx-netlab.apps-crc.testing.key  rootCA.crt  rootCA.key  rootCA.srl

$oc create route edge --service=bnginx --cert=./bnginx-netlab.apps-crc.testing/bnginx-netlab.apps-crc.testing.crt --key=./bnginx-netlab.apps-crc.testing/bnginx-netlab.apps-crc.testing.key --ca-cert=./bnginx-netlab.apps-crc.testing/rootCA.crt --port 8080 --hostname=bgninx-netlab.apps-crc.testing

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

* create a new app name bitnami/nginx
* store tls secrets bnginx-netlab.apps-crc.testing/bnginx-netlab.apps-crc.testing.key  bnginx-netlab.apps-crc.testing/bnginx-netlab.apps-crc.testing.crt as bnginx-ssl
* store  bnginx-netlab.apps-crc.testing/rootCA.crt as generic secret named ca-cert
* store bnginx.conf as configmap bnginx-config
* mount secret bnginx-ssl to /etc/nginx/ssl/ to deployment/bnginx
* mount secret ca-cert to  /etc/nginx/ssl/ca/
* mount configmap bnginx-config to /opt/bitnami/nginx/conf/server_blocks/

```
# create config file with below command
$oc new-app --name=bnginx --dry-run --image=bitnami/nginx

# we can also add ca-cert if it is not selfsigned. creating a new generic to store ca cert
$oc create secret tls bnginx-ssl --cert=./bnginx-netlab.apps-crc.testing/bnginx-netlab.apps-crc.testing.crt --key=./bnginx-netlab.apps-crc.testing/bnginx-netlab.apps-crc.testing.key 
secret/bnginx-ssl created
$oc create secret generic ca-cert --from-file=./bnginx-netlab.apps-crc.testing/rootCA.crt 
$oc create cm bnginx-config --from-file ./bnginx.conf

$oc set volumes deployment/bnginx --add --type secret --secret-name bnginx-ssl -m /etc/nginx/ssl/
info: Generated volume name: volume-8lcvr
deployment.apps/bnginx volume updated

$oc set volumes deployment/bnginx --add --type secret --secret-name ca-cert -m  /etc/nginx/ssl/ca/
info: Generated volume name: volume-drszz
deployment.apps/bnginx volume updated



$oc set volumes deployment/bnginx --add --type configmap --configmap-name bnginx-config -m /opt/bitnami/nginx/conf/server_blocks/
info: Generated volume name: volume-x8cwl
deployment.apps/bnginx volume updated


$oc get svc
NAME     TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)             AGE
bnginx   ClusterIP   10.217.5.240   <none>        8080/TCP,8443/TCP   6m27s
$oc debug -t deployment/bnginx --image curlimages/curl
Starting pod/bnginx-debug ...
Pod IP: 10.217.0.102
If you don't see a command prompt, try pressing enter.
/ $ curl --insecure https://10.217.5.240:8443
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
/ $ 
/ $ 
$oc create route passthrough bnginx --service=bnginx --port=8443
route.route.openshift.io/bnginx created
$oc get route
NAME     HOST/PORT                        PATH   SERVICES   PORT   TERMINATION   WILDCARD
bnginx   bnginx-netlab.apps-crc.testing          bnginx     8443   passthrough   None
```
# shows the cert we created.

![Screenshot from 2021-12-27 07-18-39](https://user-images.githubusercontent.com/11317624/147471208-ad8be2bc-476b-4909-aa58-11cdd8a2bbb8.png)

