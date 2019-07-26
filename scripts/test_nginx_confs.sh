#!/usr/bin/env bash

# TODO swap from `-Eeo pipefail` to `-Eeuo pipefail` above (after handling all potentially-unset variables)
set -Eeuo pipefail

cp bin/nginx-${STACK} bin/nginx

mkdir -p logs/nginx

for conf in "config/nginx.conf" "config/nginx-solo-sample.conf" ;
do
  erb ${conf}.erb > ${conf}
  if [[ "${STACK}" == "heroku-18" ]];
  then
    sed --in-place 's/#brotli/brotli/' ${conf}
  fi
  bin/nginx -t -p "`pwd`" -c ${conf}
done
