FROM node:21.5.0-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .


FROM node:21.5.0-alpine AS express

LABEL org.opencontainers.image.source=https://github.com/alexispet/final-test-Thibaut-Lecee

WORKDIR /app

COPY --from=build /app/package.json /app/
COPY --from=build /app/node_modules /app/node_modules/
COPY --from=build /app /app

EXPOSE 3000

COPY docker/entry/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD ["npm", "run", "start"]
