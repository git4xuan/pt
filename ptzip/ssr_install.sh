#!/bin/bash

chmod +x base/ssrn.sh
bash base/ssrn.sh

rm -rf /etc/init.d/shadowsocks
rsync -avrP ./conf/ssr/shadowsocks /etc/init.d/
chmod +x /etc/init.d/shadowsocks
rsync -avrP ./conf/ssr/shadowsocks.json /etc/
rsync -avrP ./conf/ssr/shadowsocks01.json /etc/

/etc/init.d/shadowsocks restart
