# Simple Kubernetes cluster on GCP with kubeadm

## Infra

* Authentication and select project :

```bash
$ gcloud auth login
$ gcloud config set project xxxxx
```

* Setup VPC and network :

```bash
$ gcloud compute networks create portefaix-kubeadm-net --subnet-mode custom
$ gcloud compute networks subnets create portefaix-kubeadm-subnet \
    --network portefaix-kubeadm-net \
    --range 10.240.0.0/24
```

* Create the firewall rules :

```bash
$ gcloud compute firewall-rules create portefaix-kubeadm-allow-internal \
  --allow tcp,udp,icmp \
  --network portefaix-kubeadm-net \
  --source-ranges 10.240.0.0/24,10.200.0.0/16
$ gcloud compute firewall-rules create portefaix-kubeadm-allow-external \
  --allow tcp:22,tcp:6443,tcp:80,icmp \
  --network portefaix-kubeadm-net \
  --source-ranges 0.0.0.0/0
```

* Create the master :

```bash
$ gcloud compute instances create portefaix-kubeadm-master \
    --can-ip-forward \
    --subnet portefaix-kubeadm-subnet \
    --image-family ubuntu-1910 \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-2 \
    --tags portefaix-kubeadm \
    --scopes cloud-platform,logging-write
```

* Create the nodes :

```bash
$ for i in 0 1; do \
    gcloud compute instances create portefaix-kubeadm-node-${i} \
        --can-ip-forward \
        --subnet portefaix-kubeadm-subnet \
        --image-family ubuntu-1910 \
        --image-project ubuntu-os-cloud \
        --machine-type n1-standard-2 \
        --tags portefaix-kubeadm \
        --scopes cloud-platform,logging-write
  done
```

## Kubernetes

On the master and nodes :

* Prepare :

```bash
$ sudo apt-get update && sudo apt-get upgrade
$ sudo apt-get install -y apt-transport-https curl
$ sudo apt-get install docker.io
$ sudo usermod -aG docker $USER
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
$ sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
$ sudo apt-mark hold kubelet kubeadm kubectl
```

* On master, initialize the cluster :

```bash
$ export KUBE_ADDRESS=""
$ sudo kubeadm init \
    --pod-network-cidr=192.168.0.0/16 \
    --apiserver-advertise-address ${KUBE_ADDRESS} \
    --ignore-preflight-errors=IsDockerSystemdCheck,SystemVerification
```

* Configuration :

```bash
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```bash
$ kubeadm token create --print-join-command
```

then on each nodes :

```bash
$ kubeadm join x.x.x.x:6443 \
    --token xxxxxxxxxxxxx \
    --discovery-token-ca-cert-hash sha256:xxxxxxxxx
```

```bash
$ kubectl get nodes
NAME                       STATUS     ROLES    AGE     VERSION
portefaix-kubeadm-master   NotReady   master   17m     v1.17.0
portefaix-kubeadm-node-0   NotReady   <none>   2m16s   v1.17.0
portefaix-kubeadm-node-1   NotReady   <none>   2m37s   v1.17.0
```

## CNI

### WeaveNet

```bash
$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
```

Then install WeaveNet :

```bash
$ kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
Check nodes :

```bash
$ kubectl get nodes
NAME                       STATUS   ROLES    AGE     VERSION
portefaix-kubeadm-master   Ready    master   20m     v1.17.0
portefaix-kubeadm-node-0   Ready    <none>   4m49s   v1.17.0
portefaix-kubeadm-node-1   Ready    <none>   5m10s   v1.17.0
```

## Cleaning Up

* Delete instances :

```bash
$ gcloud -q compute instances delete \
    portefaix-kubeadm-master portefaix-kubeadm-node-0 portefaix-kubeadm-node-1
```

* Delete the firewall rules:

```bash
$ gcloud -q compute firewall-rules delete \
    portefaix-kubeadm-allow-internal portefaix-kubeadm-allow-external
```

* Delete the network VPC:

```bash
$ gcloud -q compute networks subnets delete portefaix-kubeadm-subnet
$ gcloud -q compute networks delete portefaix-kubeadm-net
```