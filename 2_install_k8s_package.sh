
sudo mkdir -p /etc/apt/keyrings/	# 폴더가 없는 경우 생성

sudo apt install wget curl

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 234654DA9A296436


echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg



# 레포 버전 갱신
sudo apt update

# 필요한 리스트 설치
sudo apt -y install vim git curl wget kubeadm=1.28.8-1.1 kubelet=1.28.8-1.1 kubectl=1.28.8-1.1 --allow-downgrades

sudo apt-get update 

# 버전 고정 (각각의 버전이 달라지면 안된다.)
sudo apt-mark hold kubelet kubeadm kubectl

# 설치 확인
kubectl version --client && kubeadm version