create namespace q1

create a configmap index with file index.html

create bitnami/nginx deployment named bnginx and use the configmap to copy the file content to /app as index.html

run curl  http://bnginx-q1.apps-crc.testing and it should show the Hello from Quiz

```
$curl http://bnginx-q1.apps-crc.testing
<html>
<body>
<H1> Hello from Quiz! </h1>
</body>
</html>
```
