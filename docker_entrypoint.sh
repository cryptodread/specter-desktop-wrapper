#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$lightning_terminal_process" 2>/dev/null
}

echo -e "Starting Entrypoint..."
echo "Configuring LiT..."
echo "
remote.lnd.rpcserver=lnd.embassy:10009
remote.lnd.macaroonpath=/mnt/lnd/admin.macaroon
remote.lnd.tlscertpath=/mnt/lnd/tls.cert
" >> /root/.lit/lit.conf
echo "Starting LiT..."
/bin/litd --uipassword=testing1234 --lit-dir=~/.lit --letsencrypt --letsencrypthost=lightning-terminal.embassy

while true;
do
sleep 10; 
done 

trap _term SIGTERM
wait -n $lightning_terminal_process