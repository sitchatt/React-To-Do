sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo mv minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube

curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.24.0/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/
sudo chmod +x /usr/local/bin/kubectl

minikube start --driver=docker

minikube addons enable ingress

echo "You minikube is Ready and minikube ip is: ${minikube ip}"
