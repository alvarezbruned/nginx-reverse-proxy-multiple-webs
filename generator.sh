#!/bin/bash
# I=${1-'1'}
echo 'Write the number of domains you will generate and press ENTER'
read I
OUTFILE='config.sh'
OUTFILE2='default2.conf'
OUTFILE3='3prooffile.sh'
OUTFILE4='docker-compose.yml'
OUTFILE5='default.conf'
rm $OUTFILE4
ITERATION='1'
PORT='8081'
mkdir web nginx web/html nginx/config
echo 'sleep 10' >> $OUTFILE
echo 'START UPDATING DEFAULT CONF' >> $OUTFILE
while [ "$I" -ne 0 ]
do
  mkdir web/config$ITERATION
  mkdir web/html/site$ITERATION
  echo 'Give me the domain name '$ITERATION' and press ENTER'
  read DOMAI
  DOMAIN=`echo ${DOMAI,,}`
  # use $DOMAIN para lower -> ${variable,,}
  MIN=`echo $DOMAIN | cut -d '.' -f 1`
  MINS=`echo ${MIN^^}`
#  echo '[ -z "${'$MINS'_PORT_'$PORT'_TCP_ADDR}" ] && echo "\$'$MINS'_PORT_'$PORT'_TCP_ADDR is not set" || sed -i "s/'$MINS'_IP/${'$MINS'_PORT_'$PORT'_TCP_ADDR}/" /etc/nginx/conf.d/default.conf' >> $OUTFILE
#  echo '[ -z "${'$MINS'_PORT_'$PORT'_TCP_PORT}" ] && echo "\$'$MINS'_PORT_'$PORT'_TCP_PORT is not set" || sed -i "s/'$MINS'_PORT/${'$MINS'_PORT_'$PORT'_TCP_PORT}/" /etc/nginx/conf.d/default.conf' >> $OUTFILE
  MINSLOW=`echo ${MINS,,}`
#  echo 'upstream '$MINSLOW'  {' >> $OUTFILE2
#  echo '      server '$MINS'_IP:'$MINS'_PORT;' >> $OUTFILE2
#  echo '}' >> $OUTFILE2

#  echo 'server {' >> $OUTFILE3
#  echo '    listen  80;' >> $OUTFILE3
#  echo '    server_name '$DOMAIN';' >> $OUTFILE3
#  echo '    access_log  /var/log/nginx/nginx-reverse-proxy-saavedra.access.log;' >> $OUTFILE3
#  echo '    error_log  /var/log/nginx/nginx-reverse-proxy-saavedra.error.log;' >> $OUTFILE3
#  echo '    root   /var/www/html;' >> $OUTFILE3
#  echo '    index  index.html;' >> $OUTFILE3
#  echo '    location / {' >> $OUTFILE3
#  echo '     proxy_pass  http://'$MINSLOW';' >> $OUTFILE3
#  echo '     proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;' >> $OUTFILE3
#  echo '     proxy_redirect off;' >> $OUTFILE3
#  echo '     proxy_buffering off;' >> $OUTFILE3
#  echo '     proxy_set_header        Host            $host;' >> $OUTFILE3
#  echo '     proxy_set_header        X-Real-IP       $remote_addr;' >> $OUTFILE3
#  echo '     proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;' >> $OUTFILE3
#  echo '   }' >> $OUTFILE3
#  echo '}' >> $OUTFILE3
  echo 'website_'$DOMAIN':' >> $OUTFILE4
  echo '    image: albertalvarezbruned/webnginx' >> $OUTFILE4
  echo '    expose:' >> $OUTFILE4
  echo '            - "'$PORT'"' >> $OUTFILE4
  echo '    volumes:' >> $OUTFILE4
  echo '        - ./logs/:/var/log/nginx/' >> $OUTFILE4
  echo '        - ./web/html/site'$ITERATION':/var/www/html:ro' >> $OUTFILE4
  echo '        - ./web/config'$ITERATION'/default.conf:/etc/nginx/conf.d/default.conf' >> $OUTFILE4
  echo 'server {' >> $OUTFILE5
  echo '    listen  '$PORT';' >> $OUTFILE5
  echo '    server_name  _;' >> $OUTFILE5
  echo '    access_log  /var/log/nginx/project-webdev.access.log;' >> $OUTFILE5
  echo '    error_log  /var/log/nginx/project-webdev.error.log;' >> $OUTFILE5
  echo '    root   /var/www/html;' >> $OUTFILE5
  echo '    index  index.html;' >> $OUTFILE5
  echo '}' >> $OUTFILE5
  `cp $OUTFILE5 ./web/config$ITERATION/default.conf`
  rm $OUTFILE5
  echo '        - website_'$DOMAIN':'$MINSLOW >> LINKS
  rm ./web/html/site$ITERATION/index.html
  touch ./web/html/site$ITERATION/index.html
  echo '<html><head><title>My '$DOMAIN'</title></head><body>This is example of '$DOMAIN'</body></html>' > ./web/html/site$ITERATION/index.html
  let ITERATION+=1
  let PORT+=1
  let I-=1
  echo 'ou yeah'
done
echo 'echo "CHANGED DEFAULT CONF"' >> $OUTFILE
echo 'cat /etc/nginx/conf.d/default.conf' >> $OUTFILE
echo 'echo "END UPDATING DEFAULT CONF"' >> $OUTFILE
  echo 'nginx:' >> $OUTFILE4
#  echo '    build: ./nginx' >> $OUTFILE4
  echo '    image: albertalvarezbruned/nginx' >> $OUTFILE4
  echo '    expose:' >> $OUTFILE4
  echo '        - "80"' >> $OUTFILE4
  echo '        - "443"' >> $OUTFILE4
  echo '    links:' >> $OUTFILE4
`cat LINKS >> $OUTFILE4`
  echo '    ports:' >> $OUTFILE4
  echo '        - "80:80"' >> $OUTFILE4
  echo '    volumes:' >> $OUTFILE4
  echo '        - ./logs/:/var/log/nginx/' >> $OUTFILE4
  echo '        - ./nginx/config:/etc/nginx/conf.d' >> $OUTFILE4
#`chmod u+x $OUTFILE`
#`chmod u+x $OUTFILE2`
#`cat $OUTFILE3 >> $OUTFILE2`
#`cp $OUTFILE ./nginx/config/$OUTFILE`
#`cp $OUTFILE2 ./nginx/config/default.conf`
#rm $OUTFILE
#rm $OUTFILE2
rm $OUTFILE3
rm LINKS
#create Dockerfile FROM image
#mkdir nginx
#touch nginx/Dockerfile
#echo 'FROM albertalvarezbruned/nginx' >> nginx/Dockerfile
#echo '# Copy all config files' >> nginx/Dockerfile
#echo 'COPY config/default.conf /etc/nginx/conf.d/default.conf' >> nginx/Dockerfile
# echo 'COPY nginx.conf /etc/nginx/nginx.conf' >> nginx/Dockerfile
#echo 'COPY config/config.sh /etc/nginx/config.sh' >> nginx/Dockerfile
#echo 'RUN ["chmod", "+x", "/etc/nginx/config.sh"]' >> nginx/Dockerfile
#echo '# Copy default webpage' >> nginx/Dockerfile
#echo 'RUN rm /var/www/html/index.nginx-debian.html' >> nginx/Dockerfile


#echo 'COPY html/index.html /var/www/html/index.html' >> nginx/Dockerfile
# quitado no se si en gitbuh image se contempla

#echo '# Define default command.' >> nginx/Dockerfile
#echo 'CMD /etc/nginx/config.sh && nginx' >> nginx/Dockerfile
