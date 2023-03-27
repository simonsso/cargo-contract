#!/bin/sh

cd $1
shift
echo Entrypoint.sh
pwd
ls -la
echo $*
cargo contract $*
