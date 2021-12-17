# Prep

```
oc new-project network-debug
oc new-app --name app --image=nginx
```

```
for i in $(ls *.yaml);do oc apply -f $i;done

```

# Below command should return OK message, but it is returning error. Debug and fix!

```
$curl quotes-network-debug.apps-crc.testing/status
Database connection OK
```
