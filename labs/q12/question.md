# Prep

Run below command as developer

Don't look at the file until you try to solve the issue.

```
./setup.sh

```

# to recreate the lab; run `oc delete project network-debug && ./setup.sh`

# Below command should return `Database connection OK`. Debug the failure

```
$curl quotes-network-debug.apps-crc.testing/status
```
