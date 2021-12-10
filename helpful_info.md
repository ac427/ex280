#### Item 1: How to generate sample yaml with kind: Pod and volumemounts

You can look at the online help pages 

  OR

run below

```
$oc debug
Starting pod/image-debug ...
Pod IP: 10.217.0.134
If you don't see a command prompt, try pressing enter.
sh-4.4# oc get pod image-debug -o yaml
```

image-debug YAML has lot of helpful info


# some important command

```
oc adm top nodes
oc adm top pods
oc adm describe node $node_name
oc create quota -h
oc get resourcequota
oc describe quota

```

#### You can also create a pod with

```
oc run newpod --image=bitnami/nginx 

```

#### Generate pod yaml

```
oc run hazelcast --image=hazelcast/hazelcast --env="DNS_DOMAIN=cluster" --env="POD_NAMESPACE=default" --command echo hello world --dry-run=client  --labels="app=hazelcast,env=prod" -o yaml
```
