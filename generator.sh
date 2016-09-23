#!/bin/bash
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
  MINSLOW=`echo ${MINS,,}`
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
rm $OUTFILE3
rm LINKS
