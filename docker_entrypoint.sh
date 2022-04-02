#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$lightning_terminal_process" 2>/dev/null
}

echo -e "Starting Entrypoint..."


echo "Starting lightning-terminal..."
./litd --uipassword=testing

#tini -sp SIGTERM -- lightning-terminald --lnd.host=$LND_ADDRESS &
#lightning_terminal_process=$1

trap _term SIGTERM

wait -n $lightning_terminal_process