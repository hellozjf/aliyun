#!/bin/sh
# 为阿里云安装docker

# 1. 安装docker
yum install -y docker

# 2. 配置docker加速镜像
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
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