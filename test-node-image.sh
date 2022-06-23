sudo rm -rf go
sudo wget https://go.dev/dl/go1.18.3.linux-ppc64le.tar.gz
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-ppc64le.tar.gz
sudo export PATH=$PATH:/usr/local/go/bin
sudo mkdir -p go/src/k8s.io
cd go/src/k8s.io
git clone https://github.com/kubernetes/kubernetes



echo -e "Download kind source code\n" 
git clone https://github.com/kubernetes-sigs/kind.git .
echo -e "Build Kind binary from the source code present in the master\n" 
make build
echo -e "Check the kind version\n"
./bin/kind version
echo -e "Build node image for ppc64le architecture\n" 
sudo ./bin/kind build node-image --image mwaghmodepersistent/kindnode:amd64 --kube-root go/src/k8s.io/kubernetes -v=3
