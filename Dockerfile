FROM ubuntu:trusty

MAINTAINER Evgeny Safronov <division494@gmail.com>

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq install build-essential devscripts equivs git-core

# Fetch the latest codebase
RUN git clone https://github.com/cocaine/cocaine-core --recursive -b master build/cocaine-core

# Install build dependencies
RUN cd build/cocaine-core && \
    DEBIAN_FRONTEND=noninteractive mk-build-deps -ir -t "apt-get -qq --no-install-recommends"

# Build and install
RUN cd build/cocaine-core && \
    debuild -e CC -e CXX -uc -us -j$(cat /proc/cpuinfo | fgrep -c processor) && \
    debi

# Cleanup
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq purge cocaine-core-build-deps && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq purge build-essential devscripts equivs git-core && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq autoremove --purge && \
    rm -rf build

# Setup runtime environment
RUN mkdir -p /var/run/cocaine

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq install ruby-dev
RUN gem install cucumber
RUN gem install cocaine-framework --pre
