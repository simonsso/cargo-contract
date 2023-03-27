#!/bin/sh

echo Entrypoint.sh
pwd
ls -la
cargo contract $*
