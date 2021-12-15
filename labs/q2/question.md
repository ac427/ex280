create project q2
create configmap secret with variables PASSWORD=topsecret
create a pod/app named busybox, using image busybox and run command `sleep infinity` and export configmap secret as env to the pod
verify if the env is exported
