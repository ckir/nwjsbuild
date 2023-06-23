FROM i386/debian:latest

COPY sources.list /etc/apt/sources.list
RUN apt-get -qq update > /dev/null \
    && apt-get -qq install -y ca-certificates  > /dev/null \
    && apt-get -qq install -y apt-utils > /dev/null \
    && apt-get -qq install -y \
    build-essential \
    gcc-multilib \
    binutils \
    wget \
    curl \
    awscli \
    dpkg-dev \
    html2text \
    devscripts > /dev/null
COPY ./setup.sh /opt/src/scripts/setup.sh
RUN mkdir /Build /Release && chmod +x /opt/src/scripts/setup.sh
COPY .gclient /Build/
