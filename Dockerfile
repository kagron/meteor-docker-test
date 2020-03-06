FROM node:13

RUN curl https://install.meteor.com/ | sh

ARG mongo_url
ARG settings_file
ARG root_url
ARG allow_superuser

RUN mkdir /app
# COPY ./meteor/test-app /app
# COPY ./config/dev/settings.json /app
WORKDIR /app

ENV PORT=3000
ENV MONGO_URL=${mongo_url}
ENV ROOT_URL=${root_url}
ENV METEOR_ALLOW_SUPERUSER=${allow_superuser}
ENV SETTINGS_PATH=${settings_file}

# RUN echo "YOOOO: $SETTINGS_PATH"

# RUN cat $MONGO_URL

RUN npm i
RUN ls
EXPOSE 3000
# RUN "meteor --settings=${settings_file}"
# CMD meteor --settings=${SETTINGS_PATH}
# CMD ["meteor"]