FROM alpine:3.12

# hadolint ignore=DL3018
RUN \
  apk --no-cache add nodejs nodejs-npm python3 make g++ \
    curl wget build-base ca-certificates git

WORKDIR /usr/src/app

COPY ./package.json /usr/src/app/package.json
RUN npm install

COPY ./index.js /usr/src/app/

EXPOSE 9000

CMD [ "node", "index" ]
