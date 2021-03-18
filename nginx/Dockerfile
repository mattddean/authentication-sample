FROM nginx:1.19.8

# https://auth0.com/blog/load-balancing-nodejs-applications-with-nginx-and-docker/

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
