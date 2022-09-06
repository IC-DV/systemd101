#!/bin/bash
#
cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service
#
sed -i -e '/sysconfig/s/httpd/httpd-%I/' /usr/lib/systemd/system/httpd@.service
#
cat >> /etc/sysconfig/httpd-first << EOF
OPTIONS=-f conf/first.conf
EOF
#
cat >> /etc/sysconfig/httpd-second << EOF
OPTIONS=-f conf/second.conf
EOF
#
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
#
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
#
cat >> /etc/httpd/conf/first.conf << EOF
PidFile /var/run/httpd-first.pid
EOF
#
cat >> /etc/httpd/conf/second.conf << EOF
PidFile /var/run/httpd-second.pid
EOF
sed -i -e '/Listen /s/80/443/' /etc/httpd/conf/second.conf
#
systemctl start httpd@first
systemctl start httpd@second
