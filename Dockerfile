FROM node:21.5.0-alpine3.19  as build

COPY . /app/

WORKDIR /app

RUN npm ci


FROM node:21.5.0-alpine3.19 as production

LABEL org.opencontainers.image.source=https://github.com/alexispet/final-test-Thibaut-Lecee

WORKDIR /app

COPY --from=build /app/package.json .
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/  .

EXPOSE 3000

COPY docker/entry/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD ["npm", "run", "start"]