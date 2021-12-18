# Continue in the project project network-debug. Don't cleanup the deployments after solving the q12 lab

# Prep. Generate cert with fqdn quotes-network-debug.apps-crc.testing



To prove http is insecure :) 
open http://quotes-network-debug.apps-crc.testing/status in a browser and run tcpdump on crc network

```
$sudo tcpdump -i crc -A -n port 80 | grep -i database
dropped privs to tcpdump
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on crc, link-type EN10MB (Ethernet), snapshot length 262144 bytes
Database connection OK
```

Delete http route

```
oc delete route quotes
```

# Task1 
Now create a edge route for quotes and test the connection using https

# Task2
Delete the current route and create certificate with below steps and configure edge route using the cert created. 
Verify it is using the cert we created.

```
$oc delete route quotes
route.route.openshift.io "quotes" deleted
$../../scripts/cert_generator.sh quotes-network-debug.apps-crc.testing 
creating CA
Generating RSA private key, 4096 bit long modulus (2 primes)
..++++
...........................................................................++++
e is 65537 (0x010001)
generating key for the doamin $1
Generating RSA private key, 2048 bit long modulus (2 primes)
..................+++++
......................+++++
e is 65537 (0x010001)
creating csr
signing the cert using the CA credentials
Signature ok
subject=C = US, ST = CA, O = "MyOrg, Inc.", CN = quotes-network-debug.apps-crc.testing
Getting CA Private Key
$ls quotes-network-debug.apps-crc.testing/
quotes-network-debug.apps-crc.testing.crt  quotes-network-debug.apps-crc.testing.key  rootCA.key
quotes-network-debug.apps-crc.testing.csr  rootCA.crt                                 rootCA.srl
```

# Task3
* generate a new cert with below command

`../../scripts/cert_generator.sh bnginx-network-debug.apps-crc.testing`

* create tls secret name `bnginx-ssl` with certs bnginx-network-debug.apps-crc.testing/bnginx-network-debug.apps-crc.testing.crt
and bnginx-network-debug.apps-crc.testing/bnginx-network-debug.apps-crc.testing.key

* deploy app 

```
oc apply -f passthrough-deploy.yaml
```
Now create a passthrough route using for service bnginx and test the connection by running curl using cacert `./bnginx-network-debug.apps-crc.testing/rootCA.crt`. 
You can also verify in browswer the signing provider ( should be example.com) or you can run the openssl command from previous task
