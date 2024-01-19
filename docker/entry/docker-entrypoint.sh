#!/bin/sh

echo "Starting docker entrypoint"

if [ "$NODE_ENV" = "development" ]; then
  echo "Running on development mode"
  npm install
fi
  echo  "Running db:import not on development mode"
  npm run db:import

echo "Finished docker entrypoint"
exec "$@"