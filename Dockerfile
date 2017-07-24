FROM node:6.11.1
MAINTAINER Dave Long <dlong@cagedata.com>

WORKDIR /hubot

COPY package*.json ./

RUN npm install

COPY . ./

ENTRYPOINT ["./bin/hubot"]
CMD ["--name", "cagebot"]
