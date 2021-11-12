# build stage

FROM node:16.13.0 as builder

WORKDIR /app

COPY /package.json /app

RUN yarn

COPY . /app

RUN yarn build

# production stage

FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]