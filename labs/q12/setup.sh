#!/bin/bash

echo takes 30sec to run the script. hang on......
cd $(dirname "$0")
setup() {
oc new-project network-debug
oc new-app --name app --image=nginx
for i in $(ls *.yaml);do oc apply -f $i;done
oc delete deployment app
oc delete service app
}

setup &> /dev/null

# waiting for cleanup and quotes pod restarts during the deployment as it gets started too fast before mysql
sleep 30s
