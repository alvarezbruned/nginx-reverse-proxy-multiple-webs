# nginx-reverse-proxy-multiple-webs
First you must have installed bind9 and docker engine and docker-compose.
I will make a compose to create a dns container, but not now.
THE Bash file will DELETE your /etc/bind/named.conf CAREFUL! Beacuse it makes one new file with domains and restart bind9 service

#To execute:
##chmod +x *.sh && ./generator.sh && docker-compose up -d && ./nginx_gen.sh
the "generator.sh" create a docker-compose.yml but first it asks the number of domains and then de domain names.
Then it executes docker-compose up -d inside the folder.
And finally it runs the second sh "nginx_gen.sh" to create de default.conf nginx file to capture de IPs of containers and fix de ports.

The domains without "www" because script adds then.

example with 2 websites.
Generator.sh out the folder tree and docker-compose.yml. Domains demo: domain1.com domain2.com:


######website_domain1.com:
######    image: albertalvarezbruned/webnginx
######    expose:
######            - "8081"
######    volumes:
######        - ./logs/:/var/log/nginx/
######        - ./web/html/site1:/var/www/html:ro
######        - ./web/config1/default.conf:/etc/nginx/conf.d/default.conf
######website_domain2.com:
######    image: albertalvarezbruned/webnginx
######    expose:
######            - "8082"
######    volumes:
######        - ./logs/:/var/log/nginx/
######        - ./web/html/site2:/var/www/html:ro
######        - ./web/config2/default.conf:/etc/nginx/conf.d/default.conf
######nginx:
######    image: albertalvarezbruned/nginx
######    expose:
######        - "80"
######        - "443"
######    links:
######        - website_domain1.com:domain1
######        - website_domain2.com:domain2
######    ports:
######        - "80:80"
######    volumes:
######        - ./logs/:/var/log/nginx/
######        - ./nginx/config:/etc/nginx/conf.d
