FROM debian:bullseye-slim

ENV \
YARN_INSTALL="yes" \
YARN_CACHE_FOLDER="/var/cache/yarn"

RUN apt-get update \
&&  apt-get install -y --no-install-recommends \
software-properties-common \
apt-transport-https \
lsb-release \
ca-certificates \
gnupg \
gnupg1 \
gnupg2 \
wget \
git \
tini \
curl \
unzip

RUN apt-get update \
&&  curl -sL https://deb.nodesource.com/setup_16.x | bash - \
&&  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&&  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list 

RUN apt-get update \
&&  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
nodejs \
yarn

RUN set -eux; \
mkdir -p /var/cache; \
mkdir -p /var/cache/yarn; \
chmod 777 -R /var/cache

RUN set -eux; \
rm -rf /etc/apt/sources.list.d/*

COPY docker/* /usr/bin

RUN set -eux; \
chmod +x -R /usr/bin; \
chmod +x -R /usr/sbin

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]

CMD ["yarn"]