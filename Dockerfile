FROM node:lts-bullseye-slim
WORKDIR /var/www

ARG SAXON_VERSION=10.3

ADD https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/${SAXON_VERSION}/Saxon-HE-${SAXON_VERSION}.jar \
    /usr/local/saxon.jar

COPY ./docker/saxon.sh /usr/local/bin/saxon

RUN chmod a+x /usr/local/bin/saxon \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ant \
        ant-contrib \
        imagemagick \
    && npm install -g sass
