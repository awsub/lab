FROM otiai10/bwa

RUN apk add python py-pip
RUN pip install awscli