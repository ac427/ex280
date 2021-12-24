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
[root@crc-x4qnm-master-0 mnt]# dd if=/dev/zero of=loopbackfile.img bs=100M count=10
10+0 records in
10+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 3.46449 s, 303 MB/s
[root@crc-x4qnm-master-0 mnt]# losetup -fP loopbackfile.img
[root@crc-x4qnm-master-0 mnt]# losetup -a
/dev/loop0: [64516]:29697961 (/var/mnt/loopbackfile.img)
#### You don't have to create fs, but I created it anyways to debug issues. Check solution.md 
[root@crc-x4qnm-master-0 mnt]# mkfs.ext4  /var/mnt/loopbackfile.img
mke2fs 1.45.6 (20-Mar-2020)
Discarding device blocks: done                            
Creating filesystem with 256000 4k blocks and 64000 inodes
Filesystem UUID: 2a0992e0-8580-4b6f-88c8-c22e432f3f37
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

```
create new project q3

Install localstorage operator in project q3 and create loacalvolume named ex280 using the loopback device `/dev/loop0` we created in the prep. Pick either Block or any Filesystem

verify the storageclass

try to use it in a pod
