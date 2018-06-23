#!/bin/bash
ip='c.dlink.bid'
tag='/tmp/ssr/sscc'
st='restart'
mkdir -p /tmp/ssr/ 

python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 9394  -s ${ip} -p 8394  -k 'nagiZip'  -m 'chacha20' -O auth_chain_b  -o http_post  -t 300 --fast-open  -d ${st} --pid-file ${tag}-01.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 9395  -s ${ip} -p 8395  -k 'Uberdx'  -m 'chacha20' -O auth_chain_b  -o tls1.2_ticket_auth  -t 300 --fast-open  -d ${st} --pid-file ${tag}-02.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 9396  -s ${ip} -p 8396  -k 'Facedpi'  -m 'chacha20' -O auth_aes128_md5  -o http_simple  -t 300 --fast-open  -d ${st} --pid-file ${tag}-03.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 9397  -s ${ip} -p 8397  -k 'HHappy59tu'  -m 'chacha20'  -O origin  -o plain  -t 300 --fast-open  -d ${st} --pid-file ${tag}-04.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 9398  -s ${ip} -p 8398  -k 'X62peeb7'  -m 'chacha20' -O origin -o http_post   -t 300 --fast-open  -d ${st} --pid-file ${tag}-05.pid
