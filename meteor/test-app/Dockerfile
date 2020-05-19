FROM kgrondin01/simple-meteor-image:latest as base_image

ARG NODE_ENV="development"
ENV NODE_ENV=${NODE_ENV}

ARG MONGO_URL="mongodb://localhost:27017/myappdb"
ENV MONGO_URL=${MONGO_URL}

ARG ROOT_URL="http://localhost:3000"
ENV ROOT_URL=${ROOT_URL}

ENV PORT="3000"

ENV METEOR_ALLOW_SUPERUSER=true

RUN mkdir /app
WORKDIR /app

COPY . .
RUN sh /app/scripts/install_dependencies.sh 2>&1
RUN ls /bundle

EXPOSE 3000

CMD [ "sh", "/app/scripts/entrypoint.sh", " 2>&1" ]