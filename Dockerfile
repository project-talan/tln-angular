FROM nginx:1.15.7-alpine

COPY ./target/ /etc/nginx/
COPY ./dist/ /usr/share/nginx/html/
