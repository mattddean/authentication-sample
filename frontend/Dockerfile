
# https://medium.com/@shakyShane/lets-talk-about-docker-artifacts-27454560384f

# Build Environment
# Specifically tagged base image for consistency
FROM node:14.16.0 as build-deps
WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build

# Production Environment
# Specifically tagged base image for consistency
FROM nginx:1.19.8-alpine
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
