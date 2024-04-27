#!/bin/bash
set -e

rm -f /tic-tac-toe/tmp/pids/server.pid

exec "$@"
