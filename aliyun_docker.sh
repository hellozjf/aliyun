#!/bin/sh
# 为阿里云安装docker

# 1. 删除之前系统中的docker
yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# 2. 安装社区版docker
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

# 3. 配置docker加速镜像，开启ipv6
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8:1::/64",
  "hosts": ["tcp://0.0.0.0:2376","unix:///var/run/docker.sock"],
  "registry-mirrors": ["https://ci8bkzi0.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker

# 4. 启动docker
systemctl start docker
systemctl enable docker

# 5. 安装eureka（eureka放到vultr.hellozjf.com）
# docker run -d -p 8761:8761 --name eureka --restart unless-stopped springcloud/eureka

# 6. 安装mysql
#docker run -d -p 3306:3306 --name mysql --restart unless-stopped -e MYSQL_ROOT_PASSWORD=Zjf@1234 mysql

# 7. 安装ftp
docker run -d -p 20:20 -p 21:21 -p 21100-21110:21100-21110 --name vsftpd --restart unless-stopped -v /root/ftp:/home/vsftpd/hellozjf -e FTP_USER=hellozjf -e FTP_PASS=Zjf@1234 fauria/vsftpd

# 8. 安装nginx，映射10101端口到vultr6.hellozjf.com:10101
#docker run -d -p 10101:10101 --name ss-nginx 

# 9. 安装wordpress
docker run --name wordpress -e WORDPRESS_DB_HOST=vultr.hellozjf.com:3306 -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=Zjf@1234 -d --restart unless-stopped -p 80:80 wordpress

# 10. 安装tomcat
docker run -d -p 8080:8080 --name tomcat --restart unless-stopped -v /root/ftp/webapps:/usr/local/tomcat/webapps tomcat

# 11. 安装nginx，作为oss
docker run -d -p 7002:80 --name nginx-vdb1 --restart unless-stopped -v /root/ftp/vdb1:/usr/share/nginx/html:ro nginx