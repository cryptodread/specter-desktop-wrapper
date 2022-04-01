#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$loop_process" 2>/dev/null
}

echo -e "Starting Entrypoint..."

LND_ADDRESS="lnd.embassy"
LND_TLSPATH="/mnt/"
echo "Starting Loop..."
/go/bin/loopd --lnd.host=$LND_ADDRESS --lnd.tlspath=/mnt/lnd/tls.cert --lnd.macaroonpath=/mnt/lnd/admin.macaroon

#tini -sp SIGTERM -- loopd --lnd.host=$LND_ADDRESS &
#loop_process=$1

trap _term SIGTERM

wait -n $loop_process