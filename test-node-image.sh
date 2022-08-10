sudo git clone -b hosted-multi-arch https://github.com/mayurwaghmode/circleCI-multi-arch.git /root/"$GH_REPO"
sudo cd /root/"$GH_REPO"
sudo echo "Hello"
ARCH=$(uname -m)
echo "world"
sudo echo "$QUAY_REPO"
sudo echo "$QUAY_USER"
sudo buildah bud -f Dockerfile -t "$QUAY_REPO":$ARCH .
echo "$QUAY_PASS" | sudo buildah login -u "$QUAY_USER" --password-stdin quay.io
sudo podman push "$QUAY_REPO":$ARCH
