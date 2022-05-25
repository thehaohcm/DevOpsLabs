Commands for Kubernetes and AWS EKS:
1. Create K8s cluster by eksctl cmd:
  - eksctl create cluster --profile debi-lab-user --name test-cluster --version 1.21 --region ap-southeast-1 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2

2. Get nodes info by kubectl cmd:
  - kubectl get nodes

3. Get pod info by kuberctl cmd:
  - kubectl get pod

4.
  - kubectl get ns

5. Delete cluster by eksctl cmd:
  - eksctl delete cluster --name test-cluster

======
If we have a Kubernetes Manifest yaml file (ex: deployment.yml), we can follow below steps to deploy it into nodes:

1. Create a Deployment based on the YAML file:
  - kubectl apply -f deployment.yml

2. Display information about the Deployment:
  - kubectl describe deployemnt nginx-deployment

3. List the Pods created by the deployment:
  - kubectl get pods -l app=nginx

4. Display information about the Pod:
  - kubectl describe pod <pod-name>

======
Update the deployment (with a new yaml file, ex: deployment-update.yml)

1. Apply the new YAML file:
  - kubectl apply -f deployment-update.yml

2. Watch the deployment create pods with new names and delete the old pods:
  - kubectl get pods -l app=nginx

=====
Delete the deployment by name
  - kubectl delete deployment nginx-deployment

=======
Referrence:
- https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/
- https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/
- https://kubernetes.io/docs/tasks/configure-pod-container/_print/
