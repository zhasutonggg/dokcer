#使用yum方法安装docker，可以指定版本，默认安装最新版
yum install -y vim wget net-tools bash-completion
wget -O /etc/yum.repos.d/docker-ce.repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo

sed -i 's@download.docker.com@mirrors.tuna.tsinghua.edu.cn/docker-ce@g' /etc/yum.repos.d/docker-ce.repo   #修改镜像源为清华源

yum makecache fast    
yum -y install docker-ce  #安装的为最新版，你也可以指定版本



##########指定自己所需的版的###############
#yum list docker-ce.x86_64 --showduplicates | sort -r  #查看可以安装的版本
#version='18.06.3.ce-3.el7' #你自己所想要安装的版本号,可以只需部分（查找的是唯一的）
#get_version=`yum list docker-ce.x86_64 --showduplicates | sort -r |awk '{print $2}'|grep ${version}`
#yum install -y docker-ce-${get_version}
systemctl start docker
echo
echo
echo
echo
docker version
