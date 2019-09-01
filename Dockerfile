FROM nginx:1.17.3-alpine

COPY ./target/ /etc/nginx/
COPY ./dist/ /usr/share/nginx/html/
