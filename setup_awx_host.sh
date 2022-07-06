sudo dnf -y update
sudo curl https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo
sudo sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/docker-ce.repo
sudo dnf --enablerepo=docker-ce-stable -y install docker-ce
sudo dnf -y groupinstall "Development Tools"
sudo dnf -y install openssh-server git epel-release openssl ansible-core python3.9 pip

# install docker-compose
sudo DOCKER_CONFIG=/usr/local/lib/docker && \
    sudo mkdir -p $DOCKER_CONFIG/cli-plugins && \
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose && \
    sudo chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# docker-compose symlink so sudo can use it too
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# start docker
sudo systemctl start docker

# upgrade pip3 and install docker-compose module
sudo pip3 install --upgrade pip
sudo pip3 install docker-compose

# Config SSHD
# Defining the Port 22 for service and point to banner
sudo sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config

git clone -b 21.2.0 https://github.com/ansible/awx.git

cd awx

sudo make docker-compose-build

sudo make docker-compose