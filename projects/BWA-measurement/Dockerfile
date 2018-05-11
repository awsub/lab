FROM alpine

LABEL maintainer="Hiromu OCHIAI<otiai10@gmail.com>"

RUN apk update
RUN apk add \
    gcc \
    make \
    git \
    wget \
    libc-dev \
    zlib-dev \
    ncurses-dev \
    bzip2-dev \
    xz-dev

# TODO: Use wget releases source code to freeze version of BWA, just like samtools below.
RUN git clone https://github.com/lh3/bwa.git \
    && cd ./bwa \
    && make \
    && chmod 755 ./bwa \
    && mv ./bwa /bin

RUN wget https://github.com/samtools/samtools/releases/download/1.4.1/samtools-1.4.1.tar.bz2 \
    && tar -xf samtools-1.4.1.tar.bz2 \
    && cd samtools-1.4.1 \
    && make \
    && make install