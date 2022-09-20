FROM node:12 AS build

WORKDIR /app

ENV host=proto.meiji888.com
ENV port=80

COPY . .

ENV SASS_BINARY_SITE=https://npm.taobao.org/mirrors/node-sass/
RUN npm install --registry=https://registry.npm.taobao.org

RUN npm run build

FROM node:12-alpine

WORKDIR /app

COPY --from=build /app/server ./

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

ENV TZ="Asia/Shanghai"

RUN npm install --production --registry=https://registry.npm.taobao.org

EXPOSE 80

ENTRYPOINT ["npm", "run", "start"]