# 부팅 시에 overlay와 br_netfilter라는 두 가지 모듈을 로드하도록 설정합니다.
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
# overlay 커널 모듈을 즉시 로드합니다. 컨테이너 오버레이 파일 시스템에 사용됩니다.
sudo modprobe overlay

# br_netfilter 커널 모듈을 즉시 로드합니다. Linux 브리지 네트워크와 관련된 네트워크 필터링에 사용됩니다.
sudo modprobe br_netfilter

# 여기서는 몇 가지 중요한 파라미터를 설정합니다. 예를 들어, net.bridge.bridge-nf-call-iptables는 iptables가 브리지 트래픽을 처리할 수 있도록 하는 설정입니다.
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# 설정했던 값을 적용합니다.
sudo sysctl --system

# 적용 확인
lsmod | grep br_netfilter

lsmod | grep overlay

sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
