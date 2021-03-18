FROM node:14.16.0

# https://auth0.com/blog/load-balancing-nodejs-applications-with-nginx-and-docker/

WORKDIR /usr/src/app

RUN mkdir -p /usr/src/app

RUN wget https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem

COPY . /usr/src/app

RUN npm ci \
  && npm run build-prod

EXPOSE 3000

CMD [ "node", "/usr/src/app/dist/index" ]
