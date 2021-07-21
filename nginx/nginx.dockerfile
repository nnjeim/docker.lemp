FROM nginx:latest

ENV NGINX_CONF=/etc/nginx
ENV SSL=/etc/ssl

RUN rm -rf $NGINX_CONF/conf.d/default.conf
RUN mkdir -p $NGINX_CONF/sites-enabled
COPY ./conf/nginx.conf $NGINX_CONF/nginx.conf
COPY ./ssl/_wildcard.pem $SSL/certs/_wildcard.pem
COPY ./ssl/_wildcard-key.pem $SSL/private/_wildcard-key.pem
COPY ./conf.d/*.conf $NGINX_CONF/conf.d/
COPY ./sites-available/*.conf $NGINX_CONF/sites-enabled/
