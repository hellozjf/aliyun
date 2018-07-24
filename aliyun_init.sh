#!/bin/sh

# 1. 设置hostname
echo "aliyun.hellozjf.com" >/etc/hostname

# 2. 安装ipv6
wget https://raw.githubusercontent.com/hellozjf/aliyun_ipv6/master/aliyun_ipv6.sh && chmod +x aliyun_ipv6.sh && bash aliyun_ipv6.sh

# 3. 安装docker
wget https://raw.githubusercontent.com/hellozjf/aliyun_ipv6/master/aliyun_docker.sh && chmod +x aliyun_docker.sh && bash aliyun_docker.sh

# 4. 重启系统
reboot