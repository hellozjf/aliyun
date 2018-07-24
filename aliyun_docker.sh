#!/bin/sh
# 为阿里云安装docker

# 1. 安装docker
yum install -y docker

# 2. 配置docker加速镜像，开启ipv6
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64",
  "registry-mirrors": ["https://ci8bkzi0.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker

# 3. 启动docker
systemctl start docker
systemctl enable docker

# 4. 安装eureka
docker run -d -p 8761:8761 --name eureka --restart unless-stopped springcloud/eureka

# 5. 安装mysql
docker run -d -p 3306:3306 --name mysql --restart unless-stopped -e MYSQL_ROOT_PASSWORD=Zjf@1234 mysql

# 6. 安装ftp
docker run -d -p 20:20 -p 21:21 -p 21100-21110:21100-21110 --name vsftpd --restart unless-stopped -v /root/ftp:/home/vsftpd/hellozjf -e FTP_USER=hellozjf -e FTP_PASS=Zjf@1234 fauria/vsftpd

# 7. 安装nginx，映射10101端口到vultr6.hellozjf.com:10101
docker run -d -p 10101:10101 --name ss-nginx 