#!/bin/bash

Version=1.4.2
d_url=http://www.inet.no/dante/files/dante-${Version}.tar.gz
echo ${d_url}


mkdir -p /usr/src
cd /usr/src
wget -4 ${d_url}
tar -zxvf dante-${Version}.tar.gz
cd dante-${Version}

./configure \
--prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--disable-client \
--without-libwrap \
--without-bsdauth \
--without-gssapi \
--without-krb5 \
--without-upnp \
--without-pam

make && make install

/usr/sbin/sockd -v
