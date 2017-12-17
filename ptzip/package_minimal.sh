#!/bin/bash

## install package with minimal way

if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

echo ${release}

install_yum_base(){
    yum install -y wget epel-release vim nano
    yum install -y curl iproute axel htop iftop socat net-tools unzip rsync bash git
    yum install -y python
    yum install -y lrzsz python34
    yum install -y vnstat
    yum install -y mosh
    systemctl stop firewalld.service 
    systemctl disable firewalld.service
    vnstat -u -i eth0
    systemctl start vnstat
    systemctl enable vnstat 
    chpasswd -e < conf/ssh/pass.txt
}
install_apt_base(){
    apt-get install -y iproute2 curl axel htop iftop socat net-tools unzip rsync bash git wget
    apt-get install -y software-properties-common dialog vim nano
    apt-get install -y python
    apt-get install -y lrzsz mosh
    apt-get install -y proxychains vnstat chkconfig
    ufw disable
    systemctl disable ufw
    ## vnstat
    vnstat -u -i eth0
    systemctl start vnstat
    systemctl enable vnstat
    chpasswd -e < conf/ssh/pass.txt
}

install_python_pip(){
    [ ! -f get-pip.py ] && wget https://bootstrap.pypa.io/get-pip.py
    chmod +x get-pip.py
    python get-pip.py
}

install_yum_deluge(){
    wget http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    rpm -ivh nux-dextop-release-0-5.el7.nux.noarch.rpm
    yum -y install deluge-web
    pip install boost
    mkdir -p ~/.config/deluge
    rsync -avrP conf/deluge/* ~/.config/deluge/
    deluged >> /tmp/deluged.log 2>&1  
}

install_apt_deluge(){
    add-apt-repository -y ppa:deluge-team/ppa
    apt-get update -y
    apt-get install -y deluged deluge-web deluge-console
    pip install boost
    mkdir -p ~/.config/deluge
    rsync -avrP conf/deluge/* ~/.config/deluge/
    deluged >> /tmp/deluged.log 2>&1 
}

apt_force_ipv4(){
    echo "Acquire::ForceIPv4 \"true\";" >> /etc/apt/apt.conf.d/99force-ipv4
}

yum_force_ipv4(){
    echo "ip_resolve=4" >> /etc/yum.conf
}

if [[ "${release}" == "centos" ]]; then
       yum_force_ipv4
       install_yum_base
       install_python_pip
       install_yum_deluge
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
       apt_force_ipv4
       [[ ! -e "/usr/bin/wget" ]] && apt-get -y update && apt-get -y install wget
       install_apt_base
       install_python_pip
       install_apt_deluge
    else
        echo -e "Error:OS is not be supported, please change to CentOS/Debian/Ubuntu and try again."
        exit 1
    fi
