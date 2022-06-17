# build stage
FROM node:latest as build-stage
ENV NODE_OPTIONS=--openssl-legacy-provider
WORKDIR /tabix
COPY . .
RUN yarn config set registry https://registry.npm.taobao.org --global
RUN yarn config set disturl https://npm.taobao.org/dist --global
RUN echo 'nodeLinker: node-modules' > .yarnrc.yml 
RUN yarn install && yarn build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/tabix /usr/share/nginx/html/tabix
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
