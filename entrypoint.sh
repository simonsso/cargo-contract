#!/bin/sh

echo Entrypoint.sh
pwd
ls -la
cd $1
shift
echo Entrypoint.sh
pwd
ls -la
cargo contract $*
