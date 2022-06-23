sudo rm -rf $HOME/go/
sudo rm -rf go1.18.3.linux-ppc64le.tar.*
echo -e "Install and go and export the path\n" 
sudo wget https://go.dev/dl/go1.18.3.linux-ppc64le.tar.gz
sudo tar -xzf go1.18.3.linux-ppc64le.tar.gz
export PATH=$PATH:$HOME/go/bin
cd $HOME/go/
sudo mkdir $HOME/go/src/k8s.io
cd $HOME/go/src/k8s.io
echo -e "Clone the Kubernetes Source code source code\n" 
git clone https://github.com/kubernetes/kubernetes
echo -e "Download kind source code\n" 
git clone https://github.com/kubernetes-sigs/kind.git
cd $HOME/go/src/k8s.io/kind
echo -e "Build Kind binary from the source code present in the master\n" 
sudo make build
echo -e "Check the kind version\n"
./bin/kind version
echo -e "Build node image for ppc64le architecture\n" 
sudo ./bin/kind build node-image --image mwaghmodepersistent/kindnode:ppc64le --kube-root $HOME/go/src/k8s.io/kubernetes -v=3
echo -e "Install kubectl\n" 
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/ppc64le/kubectl
sudo chmod +x kubectl
sudo cp kubectl /usr/local/bin/
echo -e "Deleting existing kind cluster\n"
sudo ./bin/kind delete cluster --name kind
echo -e "Create Kind cluster\n"
KUBECONFIG="${HOME}/kind-test-config"
export KUBECONFIG
sudo ./bin/kind create cluster --image mwaghmodepersistent/kindnode:ppc64le -v=3 --wait 1m --retain
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
kubectl get services --all-namespaces -o wide
echo -e "Export logs\n"
sudo mkdir -p /tmp/kind
sudo ./bin/kind export logs /tmp/kind
echo -e "Publish Docker Image to Docker Hub\n"
echo "$DOCKERHUB_PASS" | sudo docker login -u "$DOCKERHUB_USERNAME" --password-stdin
sudo docker push mwaghmodepersistent/kindnode:ppc64le
export KUBE_VERSION=$(git -C /tmp/kubernetes log -1 --pretty='%h')
export KIND_VERSION=$(git log -1 --pretty='%h')
sudo docker tag mwaghmodepersistent/kindnode:ppc64le mwaghmodepersistent/kindnode:kind${KIND_VERSION}_k8s${KUBE_VERSION}
sudo docker push mwaghmodepersistent/kindnode:kind${KIND_VERSION}_k8s${KUBE_VERSION}
