#!/bin/bash
var=`cat ./docker-compose.yml | grep website | grep - | cut -d '_' -f 2 | cut -d ':' -f 1`
DOMAINS=( $var )
TOTAL=${#DOMAINS[@]}
I=$TOTAL
OUTFILE2='default2.conf'
OUTFILE3='3prooffile.sh'
ITERATION='0'
PORT='8081'
#rm /etc/bind/named.conf
mv /etc/bind/named.conf /etc/bind/named.conf.back
echo '// This is the primary configuration file for the BIND DNS server named.' >> /etc/bind/named.conf
echo '//' >> /etc/bind/named.conf
echo '// Please read /usr/share/doc/bind9/README.Debian.gz for information on the ' >> /etc/bind/named.conf
echo '// structure of BIND configuration files in Debian, *BEFORE* you customize ' >> /etc/bind/named.conf
echo '// this configuration file.' >> /etc/bind/named.conf
echo '//' >> /etc/bind/named.conf
echo '// If you are just adding zones, please do that in /etc/bind/named.conf.local' >> /etc/bind/named.conf
echo 'include "/etc/bind/named.conf.options";' >> /etc/bind/named.conf
echo 'include "/etc/bind/named.conf.local";' >> /etc/bind/named.conf
echo 'include "/etc/bind/named.conf.default-zones";' >> /etc/bind/named.conf
while [ "$I" -ne 0 ]
do
  DOMAIN="${DOMAINS[$ITERATION]}"
  echo $DOMAIN
  ./bind.sh $DOMAIN
  CONTAINER="$(docker ps | grep ${DOMAIN} | cut -d ' ' -f 1)"
  IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER})"
  DOMAI="${DOMAINS[$ITERATION]}"
  #DOMAIN=`echo ${DOMAI,,}`
  DOMAIN=`echo "$DOMAI" | awk '{print tolower($0)}'`
  MIN=`echo $DOMAIN | cut -d '.' -f 1`
  #MINS=`echo ${MIN^^}`
  MINS=`echo "$MIN" | awk '{print toupper($0)}'`
  #MINSLOW=`echo ${MINS,,}`
  MINSLOW=`echo "$MINS" | awk '{print tolower($0)}'`
  echo 'upstream '$MINSLOW'  {' >> $OUTFILE2
  echo '      server '$IP':'$PORT';' >> $OUTFILE2
  echo '}' >> $OUTFILE2

  echo 'server {' >> $OUTFILE3
  echo '    listen  80;' >> $OUTFILE3
  echo '    server_name '$DOMAIN';' >> $OUTFILE3
  echo '    server_name www.'$DOMAIN';' >> $OUTFILE3
  echo '    access_log  /var/log/nginx/nginx-reverse-proxy.access.log;' >> $OUTFILE3
  echo '    error_log  /var/log/nginx/nginx-reverse-proxy.error.log;' >> $OUTFILE3
  echo '    root   /var/www/html;' >> $OUTFILE3
  echo '    index  index.html;' >> $OUTFILE3
  echo '    location / {' >> $OUTFILE3
  echo '     proxy_pass  http://'$MINSLOW';' >> $OUTFILE3
  echo '     proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;' >> $OUTFILE3
  echo '     proxy_redirect off;' >> $OUTFILE3
  echo '     proxy_buffering off;' >> $OUTFILE3
  echo '     proxy_set_header        Host            $host;' >> $OUTFILE3
  echo '     proxy_set_header        X-Real-IP       $remote_addr;' >> $OUTFILE3
  echo '     proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;' >> $OUTFILE3
  echo '   }' >> $OUTFILE3
  echo '}' >> $OUTFILE3
  let ITERATION+=1
  let PORT+=1
  let I-=1
  echo 'ou yeah'
done
`chmod u+x $OUTFILE2`
`cat $OUTFILE3 >> $OUTFILE2`
`cp $OUTFILE2 ./nginx/config/default.conf`
rm $OUTFILE2
rm $OUTFILE3
NGINX=`docker ps | grep _nginx_ | cut -d ' ' -f 1`
docker exec -it $NGINX service nginx reload
