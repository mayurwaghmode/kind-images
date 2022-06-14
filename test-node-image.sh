cd ~/.go_workspace/src/sigs.k8s.io/kind
git clone https://github.com/kubernetes-sigs/kind.git .
make build
git clone https://github.com/kubernetes/kubernetes.git /tmp/kubernetes
#Build node image
./bin/kind build node-image --image mayurwaghmode/kindnode:latest --kube-root /tmp/kubernetes -v=3
#Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/ppc64le/kubectl
chmod +x kubectl
sudo cp kubectl /usr/local/bin/
#Create Kind cluster
KUBECONFIG="${HOME}/kind-test-config"
export KUBECONFIG
./bin/kind create cluster --image mayurwaghmode/kindnode:latest -v=3 --wait 1m --retain
kubectl get nodes -o wide
kubectl get pods --all-namespaces -o wide
kubectl get services --all-namespaces -o wide
mkdir -p /tmp/kind
./bin/kind export logs /tmp/kind
