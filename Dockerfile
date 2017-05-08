FROM node:0.10.48
MAINTAINER Dave Long <dlong@cagedata.com>

WORKDIR /hubot

COPY package.json .

RUN npm install

COPY . ./

ENTRYPOINT ["./bin/hubot"]
CMD ["--name", "cagebot"]
