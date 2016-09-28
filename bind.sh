#!/bin/bash
DOMAIN=${1-'domain.com'}
rm $DOMAIN'.db'
rm '/etc/bind/zones/'$DOMAIN'.db'
VPS=`hostname`
#NUM=${2-'10'}
IP=`hostname --ip-address`
echo '$TTL 10800' >> $DOMAIN'.db'
echo '$ORIGIN '$DOMAIN'.' >> $DOMAIN'.db'
echo '@ IN SOA ns1.'$DOMAIN'.    postmaster.'$DOMAIN'. (' >> $DOMAIN'.db'
echo '    2016071802  ;serial' >> $DOMAIN'.db'
echo '    21600    ;refresh after 6 hours' >> $DOMAIN'.db'
echo '    3600    ;retry after 1 hour' >> $DOMAIN'.db'
echo '    86400   ;expire after 1 week' >> $DOMAIN'.db'
echo '    86400 )    ;minimum TTL of 1 day' >> $DOMAIN'.db'
echo '@    3600    IN    A    '$IP >> $DOMAIN'.db'
echo 'ns1    172800    IN    A    '$IP >> $DOMAIN'.db'
echo 'ns2    172800    IN    A    '$IP >> $DOMAIN'.db'
echo 'www    3600    IN    CNAME   @' >> $DOMAIN'.db'
echo 'ftp    3600    IN    CNAME   @' >> $DOMAIN'.db'
echo '@    86400    IN    MX    1  mx3.ovh.net.' >> $DOMAIN'.db'
echo '@    86400    IN    MX    5  mx4.ovh.net.' >> $DOMAIN'.db'
echo '@    86400    IN    MX    100  mxb.ovh.net.' >> $DOMAIN'.db'
echo '@    172800    IN    NS    '$VPS'.' >> $DOMAIN'.db'
echo '@    172800    IN    NS    sdns2.ovh.net.' >> $DOMAIN'.db'

rm /etc/bind/zones/$DOMAIN'.db'
cp $DOMAIN'.db' /etc/bind/zones/
echo 'zone "'$DOMAIN'" {type master; file "/etc/bind/zones/'$DOMAIN'.db";};' >> /etc/bind/named.conf
service bind9 restart
