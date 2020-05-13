FROM node:13 as base_image
RUN curl https://install.meteor.com/ | sh
RUN mkdir /app
WORKDIR /app

FROM base_image as production_build
COPY meteor/test-app ./
RUN ls
ENV METEOR_ALLOW_SUPERUSER=true
RUN meteor build ../ --directory --server-only

FROM node:13 as production
ARG mongo_url='mongodb://mongo:27017/myappdb'
ARG root_url='http://localhost:80'

ENV NODE_ENV=production
ENV MONGO_URL=${mongo_url}
ENV ROOT_URL=${root_url}
ENV PORT 80

EXPOSE 80
RUN mkdir /app
WORKDIR /app
COPY --from=production_build /bundle /app
RUN cd programs/server && npm install
CMD [ "node", "main.js" ]

FROM base_image as development
ARG mongo_url='mongodb://mongo:27017/myappdb'
ARG root_url='http://localhost:3000'

ENV NODE_ENV=development
ENV MONGO_URL=${mongo_url}
ENV ROOT_URL=${root_url}
ENV METEOR_ALLOW_SUPERUSER=true
ENV PORT 3000
EXPOSE 3000

COPY meteor/test-app/package*.json ./
RUN npm install
COPY meteor/test-app/ ./
CMD [ "npm", "start" ]