
# Configure persistent loading of modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

# Load at runtime
sudo modprobe overlay
sudo modprobe br_netfilter

# Ensure sysctl params are set
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload configs
sudo sysctl --system

# Install required packages
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd
sudo apt update

sudo apt install -y containerd.io

# Configure containerd and start service
sudo mkdir -p /etc/containerd

sudo containerd config default|sudo tee /etc/containerd/config.toml

echo '
# /etc/containerd/config.toml에서 disabled_plugins 라인을 비활성화하여 CRI 인터페이스를 활성화합니다.
sudo vim /etc/containerd/config.toml
# /etc/containerd/config.toml
...
disabled_plugins = ["cri"]
=> 
# disabled_plugins = ["cri"]
...

# systemd를 cgroup driver로 사용하기
> vim /etc/containerd/config.toml
SystemdCgroup = true
===
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true


수정 후 containerd 재시작

sudo systemctl restart containerd
sudo systemctl enable containerd
systemctl status  containerd


'
