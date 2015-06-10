#!/bin/sh

sudo apt-get install libreadline-dev libconfig-dev libssl-dev lua5.2 liblua5.2-dev libevent-dev libjansson-dev libpython-dev make

git clone --recursive https://github.com/vysheng/tg.git \
&& cd tg \
&& ./configure \
&& make