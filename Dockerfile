FROM nginx:1.15.3-alpine

COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./dist/ /usr/share/nginx/html/
