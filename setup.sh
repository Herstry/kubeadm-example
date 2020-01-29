#!/bin/bash

echo "Provisioning virtual machine....."

swapoff -a
echo "root:root" | chpasswd

curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF

curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
apt-get install -y docker-ce
apt-get install kubeadm=1.15.3-00 kubelet=1.15.3-00 kubectl=1.15.3-00 ipvsadm jq -y --allow-downgrades

echo "6---"
sed -i '/swap/d' /etc/fstab
IPADDR=`ifconfig eth1 | grep Mask | awk '{print $2}'| cut -f2 -d:`
echo "KUBELET_EXTRA_ARGS=--node-ip=$IPADDR" > /etc/default/kubelet

echo "7---"
modprobe br_netfilter
modprobe ip_vs_dh
modprobe nf_conntrack_ipv4
modprobe br_netfilter >> rc.local
modprobe ip_vs_dh >> rc.local
modprobe nf_conntrack_ipv4  >> rc.local
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf
sysctl -p

echo "8---"
docker version
kubeadm version
kubelet --version
kubeadm config images pull


