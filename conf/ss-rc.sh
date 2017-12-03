#!/bin/bash

python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 2088 -s sc.dlink.bid -p 8897 -k HHappy59tu -m aes-128-cfb -o plain  -t 300 --fast-open  -d start --pid-file /tmp/ss01.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 2087 -s sc.dlink.bid -p 8397 -k HHappy59tu -m chacha20 -o plain  -t 300 --fast-open  -d start --pid-file /tmp/ss02.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 2080 -s cc.dlink.bid -p 8397 -k HHappy59tu -m chacha20 -o plain  -t 300 --fast-open  -d start --pid-file /tmp/ss03.pid
python /usr/local/shadowsocks/local.py  -b 0.0.0.0 -l 2081 -s cc.dlink.bid -p 8897 -k HHappy59tu -m aes-128-cfb -o plain  -t 300 --fast-open  -d start --pid-file /tmp/ss04.pid