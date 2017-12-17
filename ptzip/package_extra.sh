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

apt_force_ipv4(){
    echo "Acquire::ForceIPv4 \"true\";" >> /etc/apt/apt.conf.d/99force-ipv4
}

yum_force_ipv4(){
    echo "ip_resolve=4" >> /etc/yum.conf
}

install_yum_extra(){
    yum install -y wget epel-release
    yum install -y curl iproute axel htop iftop socat net-tools git zsh
    yum install -y python34
    systemctl stop firewalld.service 
    systemctl disable firewalld.service
    
}
install_apt_extra(){
    apt-get install -y iproute2 curl axel htop iftop socat net-tools 
    apt-get install -y proxychains zsh git
    apt-get install -y python3
    ufw disable
    systemctl disable ufw
}

install_python_pip3(){
    [ ! -f get-pip.py ] && wget https://bootstrap.pypa.io/get-pip.py
    chmod +x get-pip.py
    python3 get-pip.py
}

install_oh_my_zsh(){
    wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
    #sed -i 's/robbyrussell/dallas/g'   ~/.zshrc
    sed -i 's/robbyrussell/ys/g' ~/.zshrc
}

install_sys_swap(){
    swapsize=1024

# does the swap file already exist?
    grep -q "swapfile" /etc/fstab

# if not then create it
    if [ $? -ne 0 ]; then
        echo 'swapfile not found. Adding swapfile.'
        fallocate -l ${swapsize}M /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap defaults 0 0' >> /etc/fstab
    else
        echo 'swapfile found. No changes made.'
    fi

# output results to terminal
    cat /proc/swaps
    cat /proc/meminfo | grep Swap
}

install_docker(){
    curl -sSL https://get.docker.com/ | sh
}

if [[ "${release}" == "centos" ]]; then
       yum_force_ipv4
       install_yum_extra
       install_python_pip3
       install_oh_my_zsh
       install_sys_swap
       install_docker
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
       [[ ! -e "/usr/bin/wget" ]] && apt-get -y update && apt-get -y install wget
       apt_force_ipv4
       install_apt_extra
       install_python_pip3
       install_oh_my_zsh
       install_sys_swap
       install_docker
    else
        echo -e "Error:OS is not be supported, please change to CentOS/Debian/Ubuntu and try again."
        exit 1
    fi
