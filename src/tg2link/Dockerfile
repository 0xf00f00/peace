FROM --platform=${TARGETPLATFORM} python:alpine

WORKDIR /root
ARG TARGETPLATFORM
ARG VERSION
ENV VERSION ${VERSION}

RUN set -ex \
    && apk add --no-cache git gcc musl-dev tzdata py3-pip \
    && git clone https://github.com/0xf00f00/TG-FileStreamBot StreamBot \
    && mv StreamBot/* /root \
    && rm -rf StreamBot \
    && touch /root/.env \
    && pip3 install --upgrade pip \
    && pip3 install -r requirements.txt

CMD python3 -m WebStreamer