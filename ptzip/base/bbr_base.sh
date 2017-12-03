#!/bin/bash

## This shell will do not change default kernel version.
## It is ready for arm and kernel departed version.

opsy=$( get_opsy )
arch=$( uname -m )
lbit=$( getconf LONG_BIT )
kern=$( uname -r )
clear

echo "---------- System Information ----------"
echo " OS      : $opsy"
echo " Arch    : $arch ($lbit Bit)"
echo " Kernel  : $kern"
echo "----------------------------------------"
echo " Auto install latest kernel for TCP BBR"
echo
echo "----------------------------------------"
echo "   " 
sleep 1

check_bbr_status() {
    local param=$(sysctl net.ipv4.tcp_available_congestion_control | awk '{print $3}')
    if [[ "${param}" == "bbr" ]]; then
        return 0
    else
        return 1
    fi
}

sysctl_config() {
    modprobe tcp_bbr
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
    lsmod | grep bbr
}

sysctl_extra(){
    cat>/etc/sysctl.conf<<EOF
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.netdev_max_backlog = 250000
net.core.somaxconn = 4096
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_mem = 25600 51200 102400
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = bbr
#END OF LINE
EOF
sleep 1
sysctl -p >/dev/null 2>&1
}

reboot_os() {
    echo "It is been used for kernel 4.9.41+.....so It is no need for reboot os."
    echo -e "${green}Info:${plain} The system needs to reboot."
    is_reboot="y"
    if [[ ${is_reboot} == "y" || ${is_reboot} == "Y" ]]; then
        reboot
    else
        echo -e "${green}Info:${plain} Reboot has been canceled..."
        exit 0
    fi
}

enable_fastopen(){
    echo 3 > /proc/sys/net/ipv4/tcp_fastopen
    sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
    echo "net.ipv4.tcp_fastopen = 3"  >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
}

install_bbr() {
    check_bbr_status
    if [ $? -eq 0 ]; then
        echo
        echo -e "${green}Info:${plain} TCP BBR has been installed. nothing to do..."
        exit 0
    fi
    sysctl_config
    enable_fastopen
    sysctl_extra
#    reboot_os
}

cur_dir=$(pwd)
[[ $EUID -ne 0 ]] && echo -e "${red}Error:${plain} This script must be run as root!" && exit 1

[[ -d "/proc/vz" ]] && echo -e "${red}Error:${plain} Your VPS is based on OpenVZ, not be supported." && exit 1

install_bbr 2>&1 | tee ${cur_dir}/install_bbr.log