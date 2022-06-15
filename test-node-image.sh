mkdir -p ~/.go_workspace/src/sigs.k8s.io/kind
cd ~/.go_workspace/src/sigs.k8s.io/kind
git clone https://github.com/kubernetes-sigs/kind.git .
echo -e "Build Kind binary from the source code present in the master\n" 
make build
git clone https://github.com/kubernetes/kubernetes.git /tmp/kubernetes
echo -e "Build node image\n" 
./bin/kind build node-image --image mayurwaghmode/kindnode:latest --kube-root /tmp/kubernetes -v=3
echo -e "Install kubectl\n" 
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/ppc64le/kubectl
chmod +x kubectl
sudo cp kubectl /usr/local/bin/
echo -e "Create Kind cluster\n"
KUBECONFIG="${HOME}/kind-test-config"
export KUBECONFIG
./bin/kind create cluster --image mayurwaghmode/kindnode:latest -v=3 --wait 1m --retain
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
kubectl get services --all-namespaces -o wide
echo -e "Export logs\n"
mkdir -p /tmp/kind
./bin/kind export logs /tmp/kind
echo -e "Publish Docker Image to Docker Hub\n"
echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
docker push mwaghmodepersistent/kindnode:latest
export KUBE_VERSION=$(git -C /tmp/kubernetes log -1 --pretty='%h')
export KIND_VERSION=$(git log -1 --pretty='%h')
docker tag mwaghmodepersistent/kindnode:latest mwaghmodepersistent/kindnode:kind${KIND_VERSION}_k8s${KUBE_VERSION}
docker push mwaghmodepersistent/kindnode:kind${KIND_VERSION}_k8s${KUBE_VERSION}
