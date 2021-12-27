# Task 1
create quote on project quota-limit to restrict configmaps=6
check if it works if you create more than 6 configmaps

# Task 2

create project template to updte the config so any new project will have a hard limit of below resource in a project
cpu: "1"
memory: 200Mi
pods: "2"
