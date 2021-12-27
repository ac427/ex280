# Prep
on crc cluster run below to enable monitoring.

```

$crc stop
$crc config set enable-cluster-monitoring true
Successfully configured enable-cluster-monitoring to true
$crc start

```

# Create deployment bgninx --image bitnami/nginx and apply autoscale pods min=2 max=5 cpu=50%
