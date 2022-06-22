sudo rm -rf ~/.go_workspace/src/sigs.k8s.io/
sudo mkdir -p  ~/.go_workspace/src/sigs.k8s.io/
cd ~/.go_workspace/src/sigs.k8s.io/
git clone https://github.com/kubernetes-sigs/kind.git
cd kind
sudo make build
sudo rm -rf /tmp/kubernetes
git clone https://github.com/kubernetes/kubernetes.git /tmp/kubernetes
sudo ./bin/kind build node-image --image mwaghmodepersistent/kindnode:amd64 --kube-root /tmp/kubernetes -v=3
