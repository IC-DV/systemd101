#!/bin/bash
#
yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y

cat >>  /etc/sysconfig/spawn-fcgi << EOF
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s \$SOCKET -S -M 0600 -C 32 -F 1 -P /var/run/spawn-fcgi.pid -- /usr/bin/php-cgi"
EOF
#
cat >> /etc/systemd/system/spawn-fcgi.service << EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
EOF
#
systemctl start spawn-fcgi
