```
$diff .solution quotes-service.yaml 
22c22
<     targetPort: 8000
---
>     targetPort: 80
24c24
<     deployment: quotes
---
>     deployment: app
$oc apply -f solution
service/quotes configured
$curl quotes-network-debug.apps-crc.testing/status
Database connection OK
``
