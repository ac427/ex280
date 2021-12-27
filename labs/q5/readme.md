# Part 1
- make sure user linda can not create new projects
- as admin create new project named support and add user linda as admin to project support
- restore settings to original

# Part 2

- create group ex280-viewers
- add user linda to ex280-viewers
- give permissions to group ex280-viers to view cluser role and verify if linda can list pods in all namespaces
- remove linda from ex280-viewers and verify if it fails when linda tries to list pods in all namespaces


# Part 3

- Create groups qa-group, support-group uat-group  and add users joe, jill and raj to the groups
- add view clusterrole to qa-group
- add edit cluserrole to support-group
- add basic-user clusterrole to uat-group
- List the users and show the clusterroles with groups who has access
