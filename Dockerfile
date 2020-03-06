FROM node:13

RUN curl https://install.meteor.com/ | sh

ARG mongo_url
ARG root_url
ARG port

RUN mkdir /app
WORKDIR /app

ENV PORT=${port}
ENV MONGO_URL=${mongo_url}
ENV ROOT_URL=${root_url}
ENV METEOR_ALLOW_SUPERUSER=true

EXPOSE 3000