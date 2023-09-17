this repository is a  # DevOps cycle about Using CI-CD Azur Devops to automate Containerizing a spring boot app and push it to Dockerhub then in CD pull the spring-boot-app image and make deployment using kubernates 

![header](https://github.com/HaidyH/SpringBootApp/assets/83189705/715b247f-8eb1-473c-ab60-d96f914f08ac)

# Tools
```bash  
Spring
Docker
Azure devops
```
# How to use?
start by clone the repo 
```bash
git clone https://github.com/HaidyH/SpringBootApp.git
```
it's prefered to clone the repo on centos server or any linux ditribution 
you can clone it on your personal computer if you have linux or dual boot 
if you don't have use vmware to create vm or here is a repo for infrastracture on AWS
``` bash

https://github.com/HaidyH/ITI-final--project-infrastrucure
```
you need to install some tools and packages on your server 
```bash
docker
maven
minikube
helm
```
let's start with docker 

1. first remove the old version of docker (skip this step if you didn't install docker before)

```bash
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```
2. Install using the rpm repository
Set up the repository
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
3. Install Docker Engine
```bash
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```
4. Start and enable Docker
```bash
sudo systemctl enable docker
sudo systemctl start docker
   ```
5. make sure the docker service is started 
```bash
sudo systemctl status docker

   ```

to build the spring boot app image you have to install maven to create the target folder just copy the following commands
```bash
sudo yum install maven
mvn -version
   ```
```bash
 mvn clean package src
   ```

when you run the azur pipline it will build the docker images successfuly but make sure you add the docker credintials to your azure devops like the following image to push the image to docker hub  

![connect to dockerhub](https://github.com/HaidyH/SpringBootApp/assets/83189705/193b85af-2fd4-4165-98f2-71faed6b8602)

Now we need a kubernates cluster to deploy our app 
so you can simply use the AWS eks that I provieded in the infrastructure repo 
or you can deploy your cluster munually for this project we only need one node so simply use minikube 

# install minikube 

Step 1: Updating the System
```bash
sudo yum -y update
   ```
Step 2: Installing KVM Hypervisor
```bash

sudo yum -y install epel-release
   ```

```bash
sudo yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
   ```
2. Then, start and enable the libvirtd service:
```bash
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
   ```
3. Confirm the virtualization service is running with the command:      
```bash
systemctl status libvirtd
   ```
4. Next, add your user to the libvirt group:
```bash
sudo usermod -a -G libvirt $(whoami)
   ```
5. Then, open the configuration file of the virtualization service:
```bash
sudo vi /etc/libvirt/libvirtd.conf

   ```
6. Make sure that that the following lines are set with the prescribed values:

```bash
    unix_sock_group = "libvirt"
    unix_sock_rw_perms = "0770"

   ```
7. Finally, restart the service for the changes to take place:

```bash
sudo systemctl restart libvirtd.service

   ```
# Step 3: Installing Minikube

1. Download the Minikube binary package using the wget command:

```bash
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

   ```


```bash
chmod +x minikube-linux-amd64

   ```


```bash
sudo mv minikube-linux-amd64 /usr/local/bin/minikube

   ```


```bash
minikube version

   ```

# Step 4: Installing Kubectl

1. Run the following command to download kubectl:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

   ```
2. Give it executive permission:

```bash
chmod +x kubectl

   ```
3. Move it to the same directory where you previously stored Minikube:
```bash
sudo mv kubectl  /usr/local/bin/

   ```
4. Verify the installation by running:
```bash
kubectl version --client -o json

   ```
# Step 5: Starting Minikube
```bash
minikube start

   ```

Now we can easily deploy our image into kubernates cluster in stage deploy app in azure-pipeline.yml
using the deployment.yaml file in k8 directory 

but we need ingress to deploy the ingress we need service and ingress controller

# so lets deploy the ingress controller using helm chart 

# Step 1: Install helm 3 in our workstation

Install helm 3 in your Workstation where Kubectl is installed and configured.

```bash

cd ~/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

   ```
check helm version

```bash
helm version
![Screenshot 2023-09-17 221845](https://github.com/HaidyH/SpringBootApp/assets/83189705/cb3f13c1-5f09-4589-9893-2072b9798280)

   ```



# Step 2: Deploy Nginx Ingress Controller

Download latest stable release of Nginx Ingress Controller code:

```bash
controller_tag=$(curl -s https://api.github.com/repos/kubernetes/ingress-nginx/releases/latest | grep tag_name | cut -d '"' -f 4)
wget https://github.com/kubernetes/ingress-nginx/archive/refs/tags/${controller_tag}.tar.gz

   ```
Extract the file downloaded:


```bash
tar xvf ${controller_tag}.tar.gz

   ```
Switch to the directory created:

```bash
cd ingress-nginx-${controller_tag}

   ```
Change your working directory to charts folder:

```bash
cd charts/ingress-nginx/

   ```
Create namespace

```bash
kubectl create namespace ingress-nginx

   ```
Now deploy Nginx Ingress Controller using the following commands

```bash
helm install -n ingress-nginx ingress-nginx  -f values.yaml .
   ```

![Screenshot (8)](https://github.com/HaidyH/SpringBootApp/assets/83189705/b545114e-acee-422a-8e20-3a9818be00f1)

```bash
kubectl get all -n ingress-nginx
   ```
```bash
kubectl get pods -n ingress-nginx
   ```

To check logs in the Pods use the commands:

```bash
kubectl -n ingress-nginx  logs deploy/ingress-nginx-controller
   ```
To follow logs as they stream run: 

```bash
kubectl -n ingress-nginx  logs deploy/ingress-nginx-controller -f
   ```
