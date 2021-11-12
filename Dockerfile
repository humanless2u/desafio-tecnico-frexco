# development stage

FROM node:lts AS development

WORKDIR /app

COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

RUN yarn

COPY . /app

EXPOSE 3000:3000

CMD [ "yarn", "start" ]

# build stage

FROM development AS build

RUN yarn build

# production stage

FROM nginx:alpine

COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/build .

ENTRYPOINT ["nginx", "-g", "daemon off;"]