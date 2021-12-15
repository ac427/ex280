# Prep for CRC

```
$oc debug node/crc-x4qnm-master-0
Starting pod/crc-x4qnm-master-0-debug ...
To use host binaries, run `chroot /host`
Pod IP: 192.168.126.11
If you don't see a command prompt, try pressing enter.
sh-4.4# chroot /host
sh-4.4# sudo -i
[root@crc-x4qnm-master-0 ~]# cd /mnt/
[root@crc-x4qnm-master-0 mnt]# dd if=/dev/zero of=loopbackfile bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 1.05905 s, 990 MB/s
[root@crc-x4qnm-master-0 mnt]# losetup -fP loopbackfile
exit
exit
```

Install localstorage operator and create loacalvolume named ex280 using the loopback device `/dev/loop0` we created in the prep

verify the storageclass

try to use it in a pod
