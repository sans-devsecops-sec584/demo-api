FROM alpine:3.12

RUN \
  apk --update add nodejs nodejs-npm python3 make g++ \
    curl wget build-base ca-certificates git

WORKDIR /usr/src/app

ADD ./package.json /usr/src/app/package.json
RUN npm install

ADD ./index.js /usr/src/app/

EXPOSE 9000

CMD [ "node", "index" ]
