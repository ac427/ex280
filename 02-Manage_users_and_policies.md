### Get current users

```
adme.md  Readme.md
$oc get users
NAME        UID                                    FULL NAME   IDENTITIES
developer   91e87940-982a-4bac-9d89-dc58235ab63f               developer:developer
kubeadmin   bc902c7b-0adc-4141-b3f9-3071f5d0056a               developer:kubeadmin
```

### Add user abc with HTPasswd auth

```
$oc extract secret/htpass-secret -n openshift-config --to /tmp --confirm
/tmp/htpasswd
############## Important. The file doesn't have new line at the end hence running echo ##########################
$echo "" >> /tmp/htpasswd 
$htpasswd -B -b /tmp/htpasswd abc passw0rd
Adding password for user abc
$cat /tmp/htpasswd 
kubeadmin:$2a$10$EcSP9zfYjJpothmuetKhaOwOUAuqJaxCnpE4UV7pFS9VnENYyE6mW
developer:$2a$10$5sZOdEYD1tmI63QPhXa7Auv2gJ96oiN/jr3gVthujsagFJGIjTW9S
abc:$2y$05$SZXGrbjlr8wa20Av5YyxIefbURqKM5HMq3fLYqprJ8WaYcM9Pc38O
```

```
$oc set data secret/htpass-secret -n openshift-config --from-file htpasswd=/tmp/htpasswd
secret/htpass-secret data updated
$oc rollout restart deployment/oauth-openshift -n openshift-authentication
deployment.apps/oauth-openshift restarted
### Wait for the new pot to come up
$oc get pods -n openshift-authentication
NAME                               READY   STATUS        RESTARTS   AGE
oauth-openshift-79bd65d56-kfwfn    0/1     Pending       0          23s
oauth-openshift-7b898f58d4-7nzsr   1/1     Terminating   0          64s

```

### Test the login

```

$oc login -u abc -p passw0rd https://api.crc.testing:6443
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

$oc whoami
abc
```


### Deleting the htpasswd user

* Extract secret/htpass-secret to file,
* run htpasswd to delete the user from the downloaded file
* update secret/htpass-secret
* restart deployment 
