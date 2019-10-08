#!/bin/sh

set -ex

username=${USERNAME:-'username'}
password=${PASSWORD:-'password'}
redir=${REDIRECT:-''}

# secrets
cat <<EOF > /etc/ppp/chap-secrets
# Secrets for authentication using PAP
# client    server      secret      acceptable local IP addresses
$username    *           $password    *
EOF

# enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# configure firewall
iptables -t nat -I POSTROUTING -s 10.99.99.0/24 ! -d 10.99.99.0/24 -j MASQUERADE
iptables -I FORWARD -s 10.99.99.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356
iptables -I INPUT -i ppp+ -j ACCEPT
iptables -I OUTPUT -o ppp+ -j ACCEPT
iptables -I FORWARD -i ppp+ -j ACCEPT
iptables -I FORWARD -o ppp+ -j ACCEPT

# configure redir to port
test -n "$redir" && iptables -t nat -I PREROUTING -i ppp+ -p tcp -j REDIRECT --to-ports $redir

exec "$@"
