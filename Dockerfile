FROM nginx:1.15.5-alpine

COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./dist/ /usr/share/nginx/html/
RUN mkdir /etc/nginx/ssl
COPY ./ssl /etc/nginx/ssl
