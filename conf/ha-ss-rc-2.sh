#!/bin/bash
ip='45.79.89.168'
tag='/tmp/ssr/sc'
lnum=9500
onum=8894
st='restart'
mc='aes-256-cfb'
mkdir -p /tmp/ssr/ 

python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l $((${lnum}+${onum}))  -s ${ip} -p $((${onum}+0))  -k 'nagiZip'  -m ${mc} -O auth_chain_b  -o http_post  -t 300 --fast-open  -d ${st} --pid-file ${tag}-01.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l $((${lnum}+${onum}+1))  -s ${ip} -p $((${onum}+1))  -k 'Uberdx'  -m ${mc} -O auth_chain_b  -o tls1.2_ticket_auth  -t 300 --fast-open  -d ${st} --pid-file ${tag}-02.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l $((${lnum}+${onum}+2))  -s ${ip} -p $((${onum}+2))  -k 'Facedpi'  -m ${mc} -O auth_aes128_md5  -o http_simple  -t 300 --fast-open  -d ${st} --pid-file ${tag}-03.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l $((${lnum}+${onum}+3))  -s ${ip} -p $((${onum}+3))  -k 'HHappy59tu'  -m ${mc}  -O origin  -o http_simple  -t 300 --fast-open  -d ${st} --pid-file ${tag}-04.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l $((${lnum}+${onum}+4))  -s ${ip} -p $((${onum}+4))  -k 'X62peeb7'  -m ${mc} -O origin -o tls1.2_ticket_auth   -t 300 --fast-open  -d ${st} --pid-file ${tag}-05.pid
