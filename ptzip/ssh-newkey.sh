#!/bin/bash
#添加固定的文件，这里主要是自用的
##使用files文件夹下的files的newauth
##

#创建.ssh 配置文件位置


#这是public的位置，最好是http的URL便于下载
#location_pub="https://raw.githubusercontent.com/git4xuan/init/master/files/newauth.pub"
location_sshd="https://raw.githubusercontent.com/git4xuan/init/master/files/sshd_config"

if [[ ! -d /root/.ssh/ ]]; then
    mkdir /root/.ssh
fi

#backup
mv /etc/ssh/sshd_config{,.bak}

#wget  --no-check-certificate -O newauth.pub $location_pub
##注意，这里只移动没有添加，说明这是表明只有这一个公钥
mv conf/ssh/newauth.pub  ~/.ssh/authorized_keys

chmod 600   ~/.ssh/authorized_keys
chmod 700   ~/.ssh/

#更改sshd的config文件，可以使用sed，
#但是这里为了方便改为直接wget
wget  --no-check-certificate -O sshd_config $location_sshd
cp sshd_config /etc/ssh/sshd_config

#配置文件生效
systemctl restart sshd.service

