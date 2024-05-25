FROM python:3-slim-buster

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get -qq update
RUN apt-get -qq install -y --no-install-recommends --fix-missing \
        autoconf \
        automake \
        g++ \
        gcc \
        git \
        libc-ares-dev \
        libcrypto++-dev \
        libcurl4-openssl-dev \
        libfreeimage-dev \
        libnautilus-extension-dev \
        libqt4-dev \
        libsodium-dev \
        libsqlite3-dev \
        libssl-dev \
        libtool \
        m4 \
        make \
        qt4-qmake \
        swig && \
    apt-get -y autoremove

WORKDIR /megasdk

# Download and install SDK
RUN git clone https://github.com/meganz/sdk.git . && \ 
    git checkout v3.8.1 && \
    ./autogen.sh && \
    ./configure --disable-silent-rules --enable-python --with-sodium --disable-examples && \
    make -j$(nproc --all)

# Install wheel
RUN cd bindings/python/ && \
    python3 setup.py bdist_wheel && \
    cd dist/ && \ 
    pip3 install --no-cache-dir megasdk-3.8.1-*.whl