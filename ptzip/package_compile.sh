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

cpu=`uname -m`

echo ${cpu}



apt_force_ipv4(){
    echo "Acquire::ForceIPv4 \"true\";" >> /etc/apt/apt.conf.d/99force-ipv4
}

yum_force_ipv4(){
    echo "ip_resolve=4" >> /etc/yum.conf
}

install_yum_compile(){
    yum install -y gcc gcc-c++ kernel-devel make
    yum groupinstall -y "Development Tools"
}

install_apt_compile(){
    apt-get install  -y build-essential
}

install_apt_java(){
    apt-get install -y default-jdk
}

install_go_amd64(){
##install golang-tools
    bash base/goinstall.sh --64

## install for zshrc zsh needed to install
    touch "$HOME/.zshrc"
    {
        echo '# GoLang'
        echo 'export GOROOT=$HOME/.go'
        echo 'export PATH=$PATH:$GOROOT/bin'
        echo 'export GOPATH=$HOME/go'
        echo 'export PATH=$PATH:$GOPATH/bin'
    } >> "$HOME/.zshrc"
}

install_go_arm64(){
    echo "install_go_arm64"
    bash base/goinstall.sh --arm64
    touch "$HOME/.zshrc"
    {
        echo '# GoLang'
        echo "export PATH=$PATH:/usr/local/go/bin"
        echo "export GOPATH=$HOME/go"
        echo "export PATH=$PATH:$GOROOT/bin"
    } >> "$HOME/.zshrc"
}

if [[ "${release}" == "centos" ]]; then
       yum_force_ipv4
       install_yum_compile
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
       [[ ! -e "/usr/bin/wget" ]] && apt-get -y update && apt-get -y install wget
       apt_force_ipv4
       install_apt_compile
    else
        echo -e "Error:OS is not be supported, please change to CentOS/Debian/Ubuntu and try again."
        exit 1
    fi


if [[ "${cpu}" == "aarch64" ]];then
    install_go_arm64
elif [[ "${cpu}" == "x86_64" ]];then
    install_go_amd64
fi
