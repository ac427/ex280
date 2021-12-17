#!/bin/bash

setup() {
oc new-project network-debug
oc new-app --name app --image=nginx
for i in $(ls *.yaml);do oc apply -f $i;done
oc delete deployment app
oc delete service app
}

setup &> /dev/null

sleep 30s
