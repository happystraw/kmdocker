#!/bin/bash

unset HTTP_PROXY
unset HTTPS_PROXY
unset http_proxy
unset https_proxy

apt install -y tsocks

cat > /etc/tsocks.conf <<EOF
# This is the configuration for libtsocks (transparent socks)
# Lines beginning with # and blank lines are ignored
#
# The basic idea is to specify:
#       - Local subnets - Networks that can be accessed directly without
#                         assistance from a socks server
#       - Paths - Paths are basically lists of networks and a socks server
#                 which can be used to reach these networks
#       - Default server - A socks server which should be used to access
#                          networks for which no path is available
# Much more documentation than provided in these comments can be found in
# the man pages, tsocks(8) and tsocks.conf(8)

# Local networks
# For this example this machine can directly access 192.168.0.0/255.255.255.0
# (192.168.0.*) and 10.0.0.0/255.0.0.0 (10.*)

local = 192.168.31.0/255.255.255.0
local = 10.0.0.0/255.0.0.0
local = 172.18.0.0/255.255.255.0
local = kmphpfpm7.1
local = kmphpfpm5.4
local = kmnginx

# Paths
# For this example this machine needs to access 150.0.0.0/255.255.0.0 as
# well as port 80 on the network 150.1.0.0/255.255.0.0 through
# the socks 5 server at 10.1.7.25 (if this machines hostname was
# "socks.hello.com" we could also specify that, unless --disable-hostnames
# was specified to ./configure).

path {
        reaches = 150.0.0.0/255.255.0.0
        reaches = 150.1.0.0:80/255.255.0.0
        server = 10.1.7.25
        server_type = 5
        default_user = delius
        default_pass = hello
}

# Default server
# For connections that aren't to the local subnets or to 150.0.0.0/255.255.0.0
# the server at 192.168.0.1 should be used (again, hostnames could be used
# too, see note above)

server = 192.168.31.125
# Server type defaults to 4 so we need to specify it as 5 for this one
server_type = 5
# The port defaults to 1080 but I've stated it here for clarity
server_port = 32082
default_user = root
default_pass = 123
EOF

mv /usr/local/sbin/php-fpm /usr/local/sbin/php-fpm.bin
touch /usr/local/sbin/php-fpm
chmod +x /usr/local/sbin/php-fpm

cat > /usr/local/sbin/php-fpm <<EOF
#!/bin/sh
tsocks php-fpm.bin \$*
EOF
