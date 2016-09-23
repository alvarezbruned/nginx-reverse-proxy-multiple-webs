#!/bin/bash
var=`cat ./docker-compose.yml | grep website | grep - | cut -d '_' -f 2 | cut -d ':' -f 1`
DOMAINS=( $var )
TOTAL=${#DOMAINS[@]}
I=$TOTAL
OUTFILE2='default2.conf'
OUTFILE3='3prooffile.sh'
ITERATION='0'
PORT='8081'
while [ "$I" -ne 0 ]
do
  DOMAIN="${DOMAINS[$ITERATION]}"
  echo $DOMAIN
  CONTAINER="$(docker ps | grep ${DOMAIN} | cut -d ' ' -f 1)"
  IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER})"
  DOMAI="${DOMAINS[$ITERATION]}"
  DOMAIN=`echo ${DOMAI,,}`
  MIN=`echo $DOMAIN | cut -d '.' -f 1`
  MINS=`echo ${MIN^^}`
  MINSLOW=`echo ${MINS,,}`
  echo 'upstream '$MINSLOW'  {' >> $OUTFILE2
  echo '      server '$IP':'$PORT';' >> $OUTFILE2
  echo '}' >> $OUTFILE2

  echo 'server {' >> $OUTFILE3
  echo '    listen  80;' >> $OUTFILE3
  echo '    server_name '$DOMAIN';' >> $OUTFILE3
  echo '    server_name  www.'$DOMAIN';' >> $OUTFILE3
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
