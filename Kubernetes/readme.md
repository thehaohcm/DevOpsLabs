![alt text](https://github.com/thehaohcm/DevOpsLabs/blob/master/Kubernetes/IMG_2570.jpg)

Commands for Kubernetes and AWS EKS:
1. Create K8s cluster by eksctl cmd:
  - `eksctl create cluster --profile debi-lab-user --name test-cluster --version 1.22 --region ap-southeast-1 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2`

NOTICE: 
- Config k8s cluster to correct IAM user by this command:
`aws eks update-kubeconfig --name [cluster-name] --region [region-code] --profile [aim-user-name-config]`

- If encounter an issue of K8s clusters authentication, run this command to config again :
`aws eks update-kubeconfig --name test-cluster --region ap-southeast-1 --profile debi-lab-user`


2. Get nodes info by kubectl cmd:
  - `kubectl get nodes`

3. Get pod info by kuberctl cmd:
  - `kubectl get pod`

4.
  - `kubectl get ns`

5. Delete cluster by eksctl cmd:
  - `eksctl delete cluster --name test-cluster`

=======

If we have a Kubernetes Manifest yaml file (ex: deployment.yml), we can follow below steps to deploy it into nodes:

1. Create a Deployment based on the YAML file:
  - `kubectl apply -f deployment.yml`

2. Display information about the Deployment:
  - `kubectl describe deployemnt nginx-deployment`

3. List the Pods created by the deployment:
  - `kubectl get pods -l app=nginx`

Get external IP of k8s cluster:
  - `kubectl get svc --all-namespaces -o wide`

4. Display information about the Pod:
  - `kubectl describe pod <pod-name>`

=======
  
Update the deployment (with a new yaml file, ex: deployment-update.yml)

1. Apply the new YAML file:
  - `kubectl apply -f deployment-update.yml`

2. Watch the deployment create pods with new names and delete the old pods:
  - `kubectl get pods -l app=nginx`

=======
  
Delete the deployment by name
  - `kubectl delete deployment nginx-deployment`
  
  
=======

`alias ks="kubectl -n kube-system"`

`alias kgp="kubectl get pod"`
`alias kgd="kubectl get deploy"`
`alias kgs="kubectl get service"`
`alias kgn="kubectl get node"`
`alias kd="kubectl describe"`
`alias kge="kubectl get events --sort-by='.metadata.creationTimestamp' | tail -8"`

`export dy="--dry-run=client -oyaml"`

`export now="--force --grace-period 0"`

`echo "set ts=2 sts=2 sw=2 et" >> ~/.vimrc`

add label into a pod/deployments/...
  + `kubectl label [pod/deploy/...] [name] [key_1]=[value_1]...[key_N]=[value_N]`

overwrite a label
  + `kubectl label --overwrite [pod/deploy/...] [name] [key]=[value]...[key_N]=[value_N]`

create new user:
  + `kubectl config set-credentials [user_name] --client-certificate=[.crt_path] --client-key=[.key_path]`

create new context:
  + `kubectl config set-context [context_name] --user=[user_name] --cluster=[cluster_name]`

switch context:
  + `kubectl config use-context [context_name]`

CSR: is a K8s object which defines a user map to k8s (based on the key located in csr key file), then we can use kubectl to approve or deny it to use inside K8s cluster
  --option
    create a key and csr file
      + `openssl genrsa -out [filename].key 2048`
      + `openssl req -new -key [filename].key -out [filename].csr`
  --end--of--option
  create new csr with yaml format
    spec.request: [run command to get encoded 64 text: echo [filename].csr | base64 | tr -d "\n"]
  `kubectl certificate approve [csr_name] `
  create new role
  create new rolebinding

run temporary pod (and it will be removed after done) and run a command:
  + `kubectl run [pod_name] --restart=Never --image=[image_name] --rm -ti --command -- [command]`\
or `kubectl -it  run busybox --rm --image=busybox -- sh`\
ex: `kubectl run test --image=busybox --rm -ti --command -- sleep 4600`


collect osImage item of all ndoes by using jsonpath:
  + `kubectl get nodes -o jsonpath="{.item[*].status.nodeInfo.osImage}"`
or we can use jq tool to show json with pretty format:
  + `kubectl get nodes -o jsonpath | jq`
otherwise: 
  + `kubectl get nodes -o json | jq -c 'path(..)|[.[]|tostring]|join(".")' | grep -i osImage | grep -v managedFields`
install jq tool: 
  + `apt install jq`

get resources in k8s cluster and sort by creation time:
  + `kubectl api-resources --sort-by='.metadata.creationTime'`

create a new service account
  + `kubectl create sa [service_account_name]`

add serviceaccount for a pod (yaml file)
spec:
  serviceAccount: [service_account_name]
  
create role:
  + `kubectl create role [role_name] [-n [namespace]] --verb=[create,update,delete,...] --resource=[pod,configmaps,secrets]`
create rolebinding:
  + `kubectl create rolebinding [role_binding_name] [-n [namespace]] --role=[role_name] [--serviceaccount=[namespace]:[serviceaccount_name]] [--user=[user_name]]`
check auth:
  + `kubectl auth can-i [verb] [resource] --as=system:serviceaccount:[namespace]:[service_account_name]`
  
get all resource in k8s cluster:
  + `kubectl api-resources`
  
check network plugin info:
  find /etc/cni/net.d/
  then read a file inside this folder

create a secret:
  + `kubectl create secret generic [secret_name] --from-literal=[key1]=[value1] --from-literal=[key2]=[value2]...`
  
get cluster cidr network (2 ways):
  - `kubectl cluster-info dump | grep -i 'cluster-ip-range'`
  - `cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep -i 'server-cluster-ip-range'`
  - `cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep -i 'server-cluster-ip-range'`
  
change the cluster IP range CIDR:
  change ip range in 'server-ip-cluster-range' value in 2 files:
    - /etc/kubernetes/manifests/kube-apiserver.yaml 
    - /etc/kubernetes/manifests/kube-controller-manager.yaml
  (static-pod will automatically restart themself, we don't need to do anything after modifying)
  
join a node worker into cluster:\
  run this comment in the master node (ssh into master node):
    + `kubeadm token create --print-join-command`
  ssh into the new one worker node:\
    then copy the join command in the master node and past into the worker node
    
get cert info of k8s clusters (server, client cert...):
  + `openssl x509 -noout -text -in [path of the cert file]`
   ex: `openssl x509 -noout -text -in /etc/kubernetes/pki/server.crt | grep -i 'After' -A3`
  `kubeadm certs check-expiration`
  
  client certificate: /etc/kubernetes/kubelet.conf
  
renew cert with command
  + `kubeadm certs renew [service]`
  ex: `kubeadm certs renew apiserver`
  
both livenessProbe and readinessProbe are used to control health of an applicaiton
  + livenessProbe: check if container is available. Failing liveness probe will RESTART the container
  + readinessProd: check if the app is ready to be used serve traffic. Failing readiness probe will stop the applicaton from serving traffic by hiding the container's pod from corresponding Services
  + StartupProbe: check if container has properly started. StartupProbe has higher priority over the above types, which are disabled by K8s until the startup probe is successful

monitor resource in:
  - nodes: `kubectl top nodes`
  - pod: `kubectl top pods`
  - pod + pod's containers: `kubectl top pods --containers`
  - specifc pod + pods containers: `kubectl top pods [pod_name] --containers`
  
create a snapshot with ectdctl:\
  `ETCDCTL_API=3 etcdctl --endpoints [endpoint_URL:127.0.0.1]:2379 \
  --cert=[server.crt file path | /etc/kubernetes/pki/etcd/server.crt] \
  --key=[server.key file path | /etc/kubernentes/pki/etcd/server.key] \
  --cacert=[ca.crt file path | /etc/kubernetes/pki/etcd/ca.crt] \
  snapshot save [path of a new snapshot file]`
  
  - or we can config all above parameters by a way:
     + check status of etcd process by cmd: systemctl status ectd, then get its config file path. Usually, it is /etc/ectd/etcd.conf, or we can check its info in file path /etc/systemd/system/ectd
     + change the path of parameters, then save this file
     + run a simpler command: ETCDCTL_API=3 ectd snapshot save [path of a new snapshot file]
  
  - or check the pod static of etcd in /etc/kubernetes/manifests/etcd.yaml
  
  List Pod (or K8s object) with custom columes by using jsonpath:
    + `kubectl get [object] -o jsonpath="[ColumnName1]:.[jsonpath item value],[ColumnName2]:.[jsonpath item value]"`
    ex: List the nginx pod with custom columns POD_NAME and POD_STATUS
    + `kubectl get pods -o jsonpath="POD_COLUMN:.metadata.name,POD_STATUS:.status.containerStatuses[].state"`
    
  DNS in K8s
    we can nslookup a pod or service in k8s cluster with their own IP address, or use a DNS name. The DNS names are defined like:
      + with pod: <ip-address-with-hyphen>.<namespace_name>.pod
        ex: if pods IP address is 10.23.100.2 and the pod is located in default namespace 
          => DNS name is: 10-23-100-2.default.pod
      + with service: <service_name>.<namespace_name>
        ex: if a service is named "nginx-service" and it is located in default namespace
          => DNS name is: nginx-service.default
  
Cordon: mark the node as unavailable to k8s schedule
  + `kubectl cordon [node-name]`
Uncordon: mark the node as available to k8s schedule
  + `kubectl uncordon [node-name]`
Drain: evict all pods running in the node and reschedule them to run on another node
  + `kubectl drain node [node-name]`
  NOTICE: the drain cmd can only be executed in the master node, cannot execute it on worker nodes
          when you drain the node, then you want to allow it run back, execute the command UNCORDON
          DRAIN = EVICT PODs + CORDON
2nd step: `apt update && apt-cache madison kubeadm`
Taint: mark a node with a special key and value to restrict all new pods can be deployed in this
Toleration: make a pod with a taint key to indicate it can be deployed into the node which is tainted already

Network Policy\
spec:\
  podSelector:\
    matchLabels: apply this network policy for a pod which has same label\
    
spec:
  [ingress/egress]:\
    [from/to]:\
      podSelector: \
        matchLabels: allow a pod which has same label to in (ingress) or out (egress) traffic through the network policy\
      namespaceSelector:\
        matchLabels: allow all pods in a namespace which has same label to in (ingress) or out (egress) traffic through the network policy\

-------------------------------

Upgrade kubeadm & kubelet in node of cluster
1st step: Drain each node before upgrading, to make sure all new pods will not be scheduled into the node during the upgrade progress
Notice: the drain cmd can only be executed in the master node, cannot execute it on worker nodes
Notice: when you drain the node, then you want to allow it run back, execute the command UNCORDON
2nd step: `apt update && apt-cache madison kubeadm`
3rd step:
 `apt-mark unhold kubeadm && \
 apt-get update && apt-get install -y kubeadm=1.2x.x-00 && \
 apt-mark hold kubeadm`
 
4th step: upgrade the kubeadm
  `kubeadm version
  kubeadm upgrade plan
  sudo kubeadm upgrade apply v1.2x.x`

5th step: upgrade the worker nodes
  `apt-mark unhold kubelet kubectl && \
  apt-get update && apt-get install -y kubelet=1.2x.x-00 kubectl=1.2x.x-00 && \
  apt-mark hold kubelet kubectl
  sudo systemctl daemon-reload
  sudo systemctl restart kubelet`

-------------------------------

tips:
  if a question is asking for inspect to a container of pod: \
    - find which node that the pod is running inside
    - ssh into the node
    - use 'crictl ps | grep [pod_name]' to check and get pod's container_id and info
      use 'crictl inspect [pod_ip]' to get info about the container
    (use crictl command as a docker command alter)
    
  if a question asking for create a deployment which only allow one pod will be run inside one node (include master node):
    - use affinity + podAntiAffinity + (topologyKey: kubernetes.io/hostname): to make sure no node has 2 the same pod running inside
    - use toleration to run a pod in the master node (copy a declaration in daemonset k8s doc)
  => this deployment will behave as a daemonset  
  
  how to specify a pod to run a specific node:
  1. use spec.nodeName
  2. use spec.nodeSelector (with node's label)
  3. use nodeAffinity
  4. use podAffinity 
  4. use podAntiAffinity + (topologyKey: kubernete.io/hostname)
  
  How to get kubernetes manifest folder path (for static pods):
    - ps aux | grep kubelet | grep -i '--config='
    
  if a question require to create a shared volume 
    => create an emptyDir{} in volumes section in yaml file
    
  if we have to define a chain of command line in a container of pod, we have to add "/bin/sh" and "-c" command into the command section
  ex:
    command:
    - "/bin/sh"
    - "-c"
    - "echo...; echo...; echo..."
    
  if a question ask to create a pod with running a while / keep running for sometime => use command sleep 1d 
  ex:
    kubectl run [pod_name] --image=busybox [--dry-run=client -oyaml > [yaml file]] --command -- sleep 1d
    
  to make sure the service has connected to a pod/deployment/... successfully, just type command: "kubectl get ep" to check if it has a new endpoint or not => if it has a new endpoint, that means the service connected to object successfully
  
  How to print a json result by jsonpath type as a text and then use "grep" or "less -p" to search an expected keyword by using pipes in linux:
  ex: kubectl get pods -o jsonpath="{.items[*].status}" | jq . | grep -i "nodeName"
  
-------------------------------
Common commands in Kubernetes

`alias ks="kubectl -n kube-system"`

`alias kgp="kubectl get pod"`
`alias kgd="kubectl get deploy"`
`alias kgs="kubectl get service"`
`alias kgn="kubectl get node"`
`alias kd="kubectl describe"`
`alias kge="kubectl get events --sort-by='.metadata.creationTimestamp' | tail -8"`

`export dy="--dry-run=client -oyaml"`

`export now="--force --grace-period 0"`

`echo "set ts=2 sts=2 sw=2 et" >> ~/.vimrc`

add label into a pod/deployments/...
  + `kubectl label [pod/deploy/...] [name] [key_1]=[value_1]...[key_N]=[value_N]`

overwrite a label
  + `kubectl label --overwrite [pod/deploy/...] [name] [key]=[value]...[key_N]=[value_N]`

create new user:
  + `kubectl config set-credentials [user_name] --client-certificate=[.crt_path] --client-key=[.key_path]`

create new context:
  + `kubectl config set-context [context_name] --user=[user_name] --cluster=[cluster_name]`

switch context:
  + `kubectl config use-context [context_name]`

CSR: is a K8s object which defines a user map to k8s (based on the key located in csr key file), then we can use kubectl to approve or deny it to use inside K8s cluster
  --option
    create a key and csr file
      openssl genrsa -out [filename].key 2048
      openssl req -new -key [filename].key -out [filename].csr
  --end--of--option
  create new csr with yaml format
    spec.request: [run command to get encoded 64 text: echo [filename].csr | base64 | tr -d "\n"]
  kubectl certificate approve [csr_name] 
  create new role
  create new rolebinding

run temporary pod (and it will be removed after done) and run a command:
  + `kubectl run [pod_name] --restart=Never --image=[image_name] --rm -ti --command -- [command]`
  + or `kubectl -it  run busybox --rm --image=busybox -- sh`
ex: `kubectl run test --image=busybox --rm -ti --command -- sleep 4600`


collect osImage item of all ndoes by using jsonpath:
  + `kubectl get nodes -o jsonpath="{.item[*].status.nodeInfo.osImage}"`
or we can use jq tool to show json with pretty format:
  + `kubectl get nodes -o jsonpath | jq`
otherwise: 
  + `kubectl get nodes -o json | jq -c 'path(..)|[.[]|tostring]|join(".")' | grep -i osImage | grep -v managedFields`
install jq tool: 
  + `apt install jq`

get resources in k8s cluster and sort by creation time:
  + `kubectl api-resources --sort-by='.metadata.creationTime'`

create a new service account:
  + `kubectl create sa [service_account_name]`

add serviceaccount for a pod (yaml file)
spec:
  serviceAccount: [service_account_name]
  
create role:
  + `kubectl create role [role_name] [-n [namespace]] --verb=[create,update,delete,...] --resource=[pod,configmaps,secrets]`
create rolebinding:
  + `kubectl create rolebinding [role_binding_name] [-n [namespace]] --role=[role_name] [--serviceaccount=[namespace]:[serviceaccount_name]] [--user=[user_name]]`
check auth:
  + `kubectl auth can-i [verb] [resource] --as=system:serviceaccount:[namespace]:[service_account_name]`
  
get all resource in k8s cluster:
  + `kubectl api-resources`
  
check network plugin info:
  find /etc/cni/net.d/
  then read a file inside this folder

create a secret:
  + `kubectl create secret generic [secret_name] --from-literal=[key1]=[value1] --from-literal=[key2]=[value2]...`
  
get cluster cidr network (2 ways):
  - `kubectl cluster-info dump | grep -i 'cluster-ip-range'`
  - `cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep -i 'server-cluster-ip-range'`
  - `cat /etc/kubernetes/manifests/kube-controller-manager.yaml | grep -i 'server-cluster-ip-range'`
  
change the cluster IP range CIDR:
  change ip range in 'server-ip-cluster-range' value in 2 files:
    - `/etc/kubernetes/manifests/kube-apiserver.yaml`
    - `/etc/kubernetes/manifests/kube-controller-manager.yaml`
  (static-pod will automatically restart themself, we don't need to do anything after modifying)
  
join a node worker into cluster:
  run this comment in the master node (ssh into master node):
    + `kubeadm token create --print-join-command`
  ssh into the new one worker node:
    then copy the join command in the master node and past into the worker node
    
get cert info of k8s clusters (server, client cert...):
  + `openssl x509 -noout -text -in [path of the cert file]`
   ex: `openssl x509 -noout -text -in /etc/kubernetes/pki/server.crt | grep -i 'After' -A3`
  + `kubeadm certs check-expiration`
  
  client certificate: `/etc/kubernetes/kubelet.conf`
  
renew cert with command
  + `kubeadm certs renew [service]`
  ex: `kubeadm certs renew apiserver`
  
both livenessProbe and readinessProbe are used to control health of an applicaiton
  + livenessProbe: check if container is available. Failing liveness probe will RESTART the container
  + readinessProd: check if the app is ready to be used serve traffic. Failing readiness probe will stop the applicaton from serving traffic by hiding the container's pod from corresponding Services
  + StartupProbe: check if container has properly started. StartupProbe has higher priority over the above types, which are disabled by K8s until the startup probe is successful

monitor resource in:
  - nodes: `kubectl top nodes`
  - pod: `kubectl top pods`
  - pod + pod's containers: `kubectl top pods --containers`
  - specifc pod + pods containers: `kubectl top pods [pod_name] --containers`
  
create a snapshot with ectdctl
  ETCDCTL_API=3 etcdctl --endpoints [endpoint_URL:127.0.0.1]:2379 \
  --cert=[server.crt file path | /etc/kubernetes/pki/etcd/server.crt] \
  --key=[server.key file path | /etc/kubernentes/pki/etcd/server.key] \
  --cacert=[ca.crt file path | /etc/kubernetes/pki/etcd/ca.crt] \
  snapshot save [path of a new snapshot file]
  
  - or we can config all above parameters by a way:
     + check status of etcd process by cmd: systemctl status ectd, then get its config file path. Usually, it is /etc/ectd/etcd.conf, or we can check its info in file path /etc/systemd/system/ectd
     + change the path of parameters, then save this file
     + run a simpler command: ETCDCTL_API=3 ectd snapshot save [path of a new snapshot file]
  
  - or check the pod static of etcd in /etc/kubernetes/manifests/etcd.yaml
  
  List Pod (or K8s object) with custom columes by using jsonpath:
  + `kubectl get [object] -o jsonpath="[ColumnName1]:.[jsonpath item value],[ColumnName2]:.[jsonpath item value]"`
  ex: List the nginx pod with custom columns POD_NAME and POD_STATUS
  + `kubectl get pods -o jsonpath="POD_COLUMN:.metadata.name,POD_STATUS:.status.containerStatuses[].state"`
    
  DNS in K8s
    we can nslookup a pod or service in k8s cluster with their own IP address, or use a DNS name. The DNS names are defined like:
      + with pod: <ip-address-with-hyphen>.<namespace_name>.pod
        ex: if pods IP address is 10.23.100.2 and the pod is located in default namespace 
          => DNS name is: 10-23-100-2.default.pod
      + with service: <service_name>.<namespace_name>
        ex: if a service is named "nginx-service" and it is located in default namespace
          => DNS name is: nginx-service.default
  
Cordon: mark the node as unavailable to k8s schedule
  + `kubectl cordon [node-name]`
Uncordon: mark the node as available to k8s schedule
  + `kubectl uncordon [node-name]`
Drain: evict all pods running in the node and reschedule them to run on another node
  + `kubectl drain node [node-name]`
  NOTICE: the drain cmd can only be executed in the master node, cannot execute it on worker nodes
          when you drain the node, then you want to allow it run back, execute the command UNCORDON
          DRAIN = EVICT PODs + CORDON
2nd step: `apt update && apt-cache madison kubeadm`
Taint: mark a node with a special key and value to restrict all new pods can be deployed in this
Toleration: make a pod with a taint key to indicate it can be deployed into the node which is tainted already

Network Policy
spec:
  podSelector:
    matchLabels: apply this network policy for a pod which has same label
    
spec:
  [ingress/egress]:
    [from/to]:
      podSelector: 
        matchLabels: allow a pod which has same label to in (ingress) or out (egress) traffic through the network policy
      namespaceSelector:
        matchLabels: allow all pods in a namespace which has same label to in (ingress) or out (egress) traffic through the network policy

-------------------------------

Upgrade kubeadm & kubelet in node of cluster\
  - 1st step: Drain each node before upgrading, to make sure all new pods will not be scheduled into the node during the upgrade progress\
Notice: the drain cmd can only be executed in the master node, cannot execute it on worker nodes\
Notice: when you drain the node, then you want to allow it run back, execute the command UNCORDON\
  - 2nd step: apt update && apt-cache madison kubeadm\
  - 3rd step:
    + `apt-mark unhold kubeadm && \
       apt-get update && apt-get install -y kubeadm=1.2x.x-00 && \
       apt-mark hold kubeadm`
 
  - 4th step: upgrade the kubeadm
    + `kubeadm version`
    + `kubeadm upgrade plan`
    + `sudo kubeadm upgrade apply v1.2x.x`

  - 5th step: upgrade the worker nodes
    + `apt-mark unhold kubelet kubectl && \
       apt-get update && apt-get install -y kubelet=1.2x.x-00 kubectl=1.2x.x-00 && \
       apt-mark hold kubelet kubectl`
    + `sudo systemctl daemon-reload`
    + `sudo systemctl restart kubelet`

-------------------------------

tips:
  if a question is asking for inspect to a container of pod:
    - find which node that the pod is running inside
    - ssh into the node
    - use `crictl ps | grep [pod_name]` to check and get pod's container_id and info
      use `crictl inspect [pod_ip]` to get info about the container
    (use crictl command as a docker command alter)
    
  if a question asking for create a deployment which only allow one pod will be run inside one node (include master node):
    - use affinity + podAntiAffinity + (topologyKey: kubernetes.io/hostname): to make sure no node has 2 the same pod running inside
    - use toleration to run a pod in the master node (copy a declaration in daemonset k8s doc)
  => this deployment will behave as a daemonset  
  
  how to specify a pod to run a specific node:
  1. use spec.nodeName
  2. use spec.nodeSelector (with node's label)
  3. use nodeAffinity
  4. use podAffinity 
  4. use podAntiAffinity + (topologyKey: kubernete.io/hostname)
  
  How to get kubernetes manifest folder path (for static pods):
    - `ps aux | grep kubelet | grep -i '--config='`
    
  if a question require to create a shared volume 
    => create an emptyDir{} in volumes section in yaml file
    
  if we have to define a chain of command line in a container of pod, we have to add "/bin/sh" and "-c" command into the command section
  ex:
    command:
    - "/bin/sh"
    - "-c"
    - "echo...; echo...; echo..."
    
  if a question ask to create a pod with running a while / keep running for sometime => use command sleep 1d 
  ex:
    kubectl run [pod_name] --image=busybox [--dry-run=client -oyaml > [yaml file]] --command -- sleep 1d
    
  to make sure the service has connected to a pod/deployment/... successfully, just type command: "kubectl get ep" to check if it has a new endpoint or not => if it has a new endpoint, that means the service connected to object successfully
  
  How to print a json result by jsonpath type as a text and then use "grep" or "less -p" to search an expected keyword by using pipes in linux:
  ex: kubectl get pods -o jsonpath="{.items[*].status}" | jq . | grep -i "nodeName"
  
-------------------------------

linux stuff tips:
  find a text with insensitiy case:
    + `grep -i '[word]'`
    
  find multi texts with insensity case:
    + `grep -i -e '^([word1]|[word2])'`
    
  count line number:
    + `wc -l`
    
  replace a word with another word:
    + `sed -i 's/[word1]/[word2]/g'`
    
  check response of url:
    + `curl -s [url/pod_name/service_name/ip]:[port]`
    
  get an absolute path of a file:
    + `readlink -f [file_name]`
    
  get a specific column data:
    + `awk '{print $[column_num]}'`
    
  encode data 
    + `echo -n "[word]" | base64`
    (notice: "-n" paramter means don't print new line character)
    
  decode data
    + `echo "[word]" | base64 --decode`
    
  get last "n" line of a content
    + `cat [file] | tail -[n]`
    
  get first "n" line of a content
    + `cat [file] | head -[n]`
    
-------------------------------

Notice:
  - If the nod is running out of resource, k8s will consider to terminate all pods that are using more than their request. That means all pod which doesn't have any "requests" section will be considered to terminated. To check them, just run command: 
    + `kubectl describe pods | grep -e -i "^(name:| requests:)" -A1`
    => all shown pods are pods that required resource, remove them from the considered list, then all the rest will be terminated
    + `kubectl get pod -o jsonpath="{range .items[*]} {.metadata.name} {.spec.containers[*].resources}{'\n'}"`

=======
Referrence:
- https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/
- https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/
- https://kubernetes.io/docs/tasks/configure-pod-container/_print/
