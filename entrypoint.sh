#!/bin/sh
set -e

verb="--verbose"
if [ "$QUIET" = true ]; then
  verb=""
fi

ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

mkdir -p /etc/elastalert/
mkdir -p /etc/elastalert-rules/
envsubst < config.yaml > "/etc/elastalert/config.yaml";
for r in rules/*; do
  envsubst < "$r" > "/etc/elastalert-$r";
done

cd /etc/elastalert
elastalert-create-index
if [[ ! -z $TRACE ]]; then
    touch /app/query.log
    param="--es_debug_trace /app/query.log"
fi

python3 -m elastalert.elastalert $verb $param
