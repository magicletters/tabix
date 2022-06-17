# build stage
FROM node:latest as build-stage
ENV NODE_OPTIONS=--openssl-legacy-provider
WORKDIR /tabix
COPY . .
RUN echo 'nodeLinker: node-modules' > .yarnrc.yml && yarn install && yarn build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/tabix /usr/share/nginx/html/tabix
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
