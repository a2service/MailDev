FROM alpine:3.3
MAINTAINER "Dan Farrelly <daniel.j.farrelly@gmail.com>"

ENV NODE_ENV production

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD package.json /usr/src/app/

# do everything in one go (decrease overall image size)
RUN apk add --no-cache nodejs &&\
    apk add --no-cache --virtual build-dependencies python make g++ &&\
    npm install && npm prune &&\
    apk del build-dependencies &&\
    rm -fr /root/.npm \
           /root/.node-gyp \
           /tmp/*

ADD . /usr/src/app

EXPOSE 1080 25

CMD ["bin/maildev", "--web", "1080", "--smtp", "25"]
