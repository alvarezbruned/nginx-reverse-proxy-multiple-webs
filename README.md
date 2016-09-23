# nginx-reverse-proxy-multiple-webs
First you must have installed bind9 and docker engine and docker-compose.
I will make a compose to create a dns container, but not now.

the "generator.sh" create a docker-compose.yml but first it asks the number of domains and then de domain names.
And it's necessary execute the second sh "nginx_gen.sh" to create de default.conf nginx file to capture de IPs of containers and fix de ports.

example with 2 websites this it makes de generator.sh with answer 2 domains and domain names: domain1.com domain2.com:

website_domain1.com:
    image: albertalvarezbruned/webnginx
    expose:
            - "8081"
    volumes:
        - ./logs/:/var/log/nginx/
        - ./web/html/site1:/var/www/html:ro
        - ./web/config1/default.conf:/etc/nginx/conf.d/default.conf
website_domain2.com:
    image: albertalvarezbruned/webnginx
    expose:
            - "8082"
    volumes:
        - ./logs/:/var/log/nginx/
        - ./web/html/site2:/var/www/html:ro
        - ./web/config2/default.conf:/etc/nginx/conf.d/default.conf
nginx:
    image: albertalvarezbruned/nginx
    expose:
        - "80"
        - "443"
    links:
        - website_domain1.com:domain1
        - website_domain2.com:domain2
    ports:
        - "80:80"
    volumes:
        - ./logs/:/var/log/nginx/
        - ./nginx/config:/etc/nginx/conf.d
