#!/usr/bin/env bash

if pgrep "$@" &> /dev/null
then
  pkill "$@"
else
  EXEC=$(command -v $@)
  if test "$EXEC"
  then
    exec "$EXEC"
  else
    exit 1
  fi
fi
