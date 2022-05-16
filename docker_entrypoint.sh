#!/bin/bash

_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$specter_desktop_process" 2>/dev/null
}
# Setting variables
# TOR_ADDRESS=$(yq e '.tor-address' /root/start9/config.yaml)
# LAN_ADDRESS=$(yq e '.lan-address' /root/start9/config.yaml)
SPECTER_MODE=$(yq e '.specter-desktop.mode' /root/start9/config.yaml)
SPECTER_PASS=$(yq e '.password' /root/start9/config.yaml)
RPC_TYPE=$(yq e '.bitcoind.type' /root/start9/config.yaml)
RPC_USER=$(yq e '.bitcoind.user' /root/start9/config.yaml)
RPC_PASS=$(yq e '.bitcoind.password' /root/start9/config.yaml)
if [ "$RPC_TYPE" = "internal-proxy" ]; then
	RPC_HOST="btc-rpc-proxy.embassy"
	echo "Running on Bitcoin Proxy..."
else
	RPC_HOST="bitcoind.embassy"
	echo "Running on Bitcoin Core..."
fi
echo "Configuring Specter Desktop..."

# Properties Page showing password to be used for login
  echo 'version: 2' >> /root/start9/stats.yaml
  echo 'data:' >> /root/start9/stats.yaml
  echo '  Password: ' >> /root/start9/stats.yaml
        echo '    type: string' >> /root/start9/stats.yaml
        echo "    value: \"$SPECTER_PASS\"" >> /root/start9/stats.yaml
        echo '    description: This is your admin password for Specter Desktop. Please use caution when sharing this password, you could lose your funds!' >> /root/start9/stats.yaml
        echo '    copyable: true' >> /root/start9/stats.yaml
        echo '    masked: true' >> /root/start9/stats.yaml
        echo '    qr: false' >> /root/start9/stats.yaml
echo "Starting Specter Desktop..."
if [ "$SPECTER_MODE" = "server" ] then
  python3 -m cryptoadvance.specter server
else
  python3 -m cryptoadvance.specter bitcoind
fi
# Run all tests but not the elements
pytest -m "not elm"

while true
do sleep 10;
done

trap _term SIGTERM
wait -n $specter_desktop_process