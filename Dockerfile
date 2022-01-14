FROM php:7.4-cli-alpine

ARG PHPMD_VERSION=2.11.1

RUN wget -P /usr/local/bin -q https://github.com/phpmd/phpmd/releases/download/${PHPMD_VERSION}/phpmd.phar \
 && chmod +x /usr/local/bin/phpmd.phar

RUN apk --no-cache add git bash \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /tmp
