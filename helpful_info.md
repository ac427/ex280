#### Item 1: How to generate sample yaml with kind: Pod and volume mounts

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

