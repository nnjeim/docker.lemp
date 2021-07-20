FROM nginx:latest

RUN apt install bash
RUN rm -rf /etc/nginx/conf.d/default.conf
RUN mkdir -p /etc/nginx/sites-enabled
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./ssl/_wildcard.pem /etc/ssl/certs/_wildcard.pem
COPY ./ssl/_wildcard-key.pem /etc/ssl/private/_wildcard-key.pem
COPY ./conf.d/*.conf /etc/nginx/conf.d/
COPY ./sites-available/*.conf /etc/nginx/sites-enabled/
