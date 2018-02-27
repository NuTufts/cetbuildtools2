#!/usr/bin/env bash

__SYSTEM_LIBRARY_PATH_NAME="LD_LIBRARY_PATH"
if [[ $(uname) == 'Darwin' ]]; then
  __SYSTEM_LIBRARY_PATH_NAME="DYLD_LIBRARY_PATH"
fi
echo "x${!__SYSTEM_LIBRARY_PATH_NAME}x"
