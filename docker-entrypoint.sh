#!/bin/bash

# Exit on fail
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ -f Gemfile ]; then
  # Ensure all gems installed. Add binstubs to bin which has been added to PATH in Dockerfile.
  bundle check || bundle install && bundle binstubs --all
fi

if [ $# -eq 0 ]; then
  if [[ -f Gemfile ]]; then
   exec rails s -b 0.0.0.0
  else
	 exec /bin/bash
  fi
else
	echo "exec command => $@"
	exec "$@"
fi