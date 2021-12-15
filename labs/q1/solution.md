```
oc new-project q1
oc create configmap index --from-file=./index.html 
oc new-app --name bnginx --image=bitnami/nginx --dry-run=true -o yaml > bnginx.yaml
```

From the document look for configmap example ( on 4.5 docs it is under  Authentication and authorization - Creating and using config maps )
update bnginx.yaml with below syntax. check bnginx.yaml file line 65 to 71

```
          volumeMounts:
            - name: config-volume
              mountPath: /app
        volumes:
          - name: config-volume
            configMap:
              name: index
```

```
oc apply -f bnginx.yaml
oc expose service bnginx
curl http://bnginx-q1.apps-crc.testing
```
