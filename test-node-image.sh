sudo rm -rf ~/.go_workspace/src/sigs.k8s.io/kind
sudo rm -rf /tmp/kubernetes
sudo mkdir -p ~/.go_workspace/src/sigs.k8s.io/kind
sudo chown ubuntu:ubuntu ~/.go_workspace/src/sigs.k8s.io/kind
cd ~/.go_workspace/src/sigs.k8s.io/kind
echo -e "Download kind source code\n" 
git clone https://github.com/kubernetes-sigs/kind.git .
echo -e "Build Kind binary from the source code present in the master\n" 
make build
echo -e "Check the kind version\n"
./bin/kind version
echo -e "Download kubernetes source code\n" 
git clone https://github.com/kubernetes/kubernetes.git /tmp/kubernetes
sudo ./bin/kind build node-image --image mwaghmodepersistent/kindnode:amd64 --kube-root /tmp/kubernetes -v=3
