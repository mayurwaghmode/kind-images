sudo rm -rf $HOME/go/
sudo rm -rf go1.18.3.linux-ppc64le.tar.*
echo -e "Release the node image\n"
echo -e "Install and go and export the path\n" 
sudo wget https://go.dev/dl/go1.18.3.linux-ppc64le.tar.gz
sudo tar -xzf go1.18.3.linux-ppc64le.tar.gz
export PATH=$PATH:$HOME/go/bin
cd $HOME/go/
sudo mkdir $HOME/go/src/k8s.io
cd $HOME/go/src/k8s.io
echo -e "Clone the Kubernetes Source code source code\n" 
git clone -b v1.24.3 https://github.com/kubernetes/kubernetes
echo -e "Download kind\n" 
wget https://github.com/kubernetes-sigs/kind/releases/download/v0.14.0/kind-linux-ppc64le
chmod u+x kind-linux-ppc64le
mv kind-linux-ppc64le /usr/local/bin/kind
echo -e "Check the kind version\n"
kind version
echo -e "Build node image for ppc64le architecture\n" 
sudo kind build node-image --image quay.io/mayurwaghmode111/node-ppc64le:ppc64le --kube-root $HOME/go/src/k8s.io/kubernetes -v=3
echo -e "Install kubectl\n" 
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/ppc64le/kubectl
sudo chmod +x kubectl
sudo cp kubectl /usr/local/bin/
echo -e "Deleting existing kind cluster\n"
sudo kind delete cluster --name kind
echo -e "Create Kind cluster\n"
KUBECONFIG="${HOME}/kind-test-config"
export KUBECONFIG
sudo kind create cluster --image quay.io/mayurwaghmode111/node-ppc64le:ppc64le -v=3 --wait 1m --retain
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
kubectl get services --all-namespaces -o wide
echo -e "Export logs\n"
sudo mkdir -p /tmp/kind
sudo kind export logs /tmp/kind
echo -e "Publish Docker Image to Docker Hub\n"
echo "$QUAY_PASS" | sudo docker login quay.io -u "$QUAY_USERNAME" --password-stdin
sudo docker push quay.io/mayurwaghmode111/node-ppc64le:ppc64le
