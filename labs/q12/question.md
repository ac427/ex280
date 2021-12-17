
# Prep
```
oc new-project network-debug
oc new-app --name app --image=nginx
```

```
for i in $(ls *.yaml);do oc apply -f $i;done

```


