#!/bin/sh
set -e

echo "Starting docker entrypoint"

if [ "$ENV_MODE" = "development" ]; then
  echo "Running on development mode"
  npm install
fi
  npm run db:import

echo "Finished docker entrypoint"
exec "$@"