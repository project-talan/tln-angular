FROM nginx:1.19.1-alpine

COPY ./target/ /etc/nginx/
COPY ./dist/ /usr/share/nginx/html/
