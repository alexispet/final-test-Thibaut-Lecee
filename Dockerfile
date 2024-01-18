FROM node:21.6.0-alpine3.19 AS build

COPY . /app/

WORKDIR /app

RUN npm install


FROM node:21.6.0-alpine3.19 as production

LABEL org.opencontainers.image.source=https://github.com/alexispet/final-test-Thibaut-Lecee

WORKDIR /app

COPY --from=build /app/package.json .
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/  .

EXPOSE 3000

COPY docker/entryPoint/docker-entrypoint.sh /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

CMD ["npm", "run", "start"]