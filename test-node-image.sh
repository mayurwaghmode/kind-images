rm -rf ~/.go_workspace/src/sigs.k8s.io/kind
rm -rf /tmp/kubernetes
mkdir -p ~/.go_workspace/src/sigs.k8s.io/kind
sudo chown ubuntu:ubuntu ~/.go_workspace/src/sigs.k8s.io/kind
cd ~/.go_workspace/src/sigs.k8s.io/kind
git clone https://github.com/kubernetes-sigs/kind.git .
make build
git clone https://github.com/kubernetes/kubernetes.git /tmp/kubernetes
./bin/kind build node-image --image mwaghmodepersistent/kindnode:amd64 --kube-root /tmp/kubernetes -v=3
