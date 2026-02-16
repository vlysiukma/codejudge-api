#!/bin/sh
set -e
if [ "$1" = "rails" ] || [ "$1" = "rake" ]; then
  exec bundle exec "$@"
fi
exec "$@"
