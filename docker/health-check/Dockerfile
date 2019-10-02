FROM node:lts-alpine

WORKDIR /usr/src
COPY method-curl.js .
COPY config.js .
COPY package.json .
COPY notify-slack.js .
COPY sites.js .

RUN npm install

