# Task 1

In a 3 node cluster, create a deployment with image bitnami/nginx with replicas=4. Make sure you have only 1 pod per node and the 4th pod
should be in pending state as it fails the requirement

If you are on CRC, make it replacas of 2 and the second pod should be in pending state.

If you want a multi node cluster, you can spin a kube cluster as the concepts are same. I am running a kube cluster using 
https://github.com/ac427/libvirt-k8s . There are also solutions like https://github.com/scriptcamp/vagrant-kubeadm-kubernetes which I haven't tested


# Task 2

label 2 nodes type=dev in a cluster or the one node in crc cluster.
create deployment with image bitnami/nginx with replicas=4. The pods should run only on the nodes with type=dev label
