# Prep for CRC

```
$oc debug node/crc-x4qnm-master-0
Starting pod/crc-x4qnm-master-0-debug ...
To use host binaries, run `chroot /host`
chroot /host
Pod IP: 192.168.126.11
If you don't see a command prompt, try pressing enter.
sh-4.4# chroot /host
sh-4.4# sudo -i
[root@crc-x4qnm-master-0 ~]# cd /mnt
[root@crc-x4qnm-master-0 mnt]#  dd if=/dev/zero of=ex280-q3 bs=1M count=1000
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 1.48032 s, 708 MB/s
[root@crc-x4qnm-master-0 mnt]# losetup -fP ex280-q3
[root@crc-x4qnm-master-0 mnt]# ls /dev/loop
loop-control  loop0         
[root@crc-x4qnm-master-0 mnt]# ls -ltr /dev/loop0
brw-rw----. 1 root disk 7, 0 Dec 14 20:28 /dev/loop0
[root@crc-x4qnm-master-0 mnt]# logout
sh-4.4# exit
sh-4.4# exit

Removing debug pod ...
```

Install localstorage operator and create loacalvolume named ex280 using the loopback device `/dev/loop1` we created in the prep

verify the storageclass

try to use it in a pod
