#二进制安装docker
docker_package='https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz'
yum install -y wget vim bash-completion
mkdir /data && cd /data
wget -c ${docker_package}
pak_name=`ls | grep 'docker'`
tar -xf ${pak_name}
cat >> /etc/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/data/docker/:/bin:/sbin:/usr/bin:/usr/sbin"
EnvironmentFile=-/run/flannel/docker
ExecStart=/data/docker/dockerd --log-level=error $DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.targe
EOF

cat >>/etc/profile.d/docker.sh<<EOF
export PATH=/data/docker:$PATH
EOF

source /etc/profile.d/docker.sh


wget -O /usr/share/bash-completion/completions/docker https://raw.githubusercontent.com/alonghub/Docker/master/Resource/docker

#配置docker镜像加速，基于阿里云，这里的registry-mirrors需要自己阿里云账号的
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://p524jkcw.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker


systemctl stop firewalld
systemctl disable firewalld
#临时关闭
setenforce 0
#永久关闭重启生效
sed -i 's/=enforcing/=disabled/' /etc/sysconfig/selinux

systemctl start docker
echo
echo
echo
docker version

