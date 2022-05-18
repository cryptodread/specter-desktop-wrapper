#!/bin/bash
set -a 
_term() { 
  echo "Caught SIGTERM signal!" 
  kill -TERM "$specter_desktop_process" 2>/dev/null
}
# Setting variables
echo "Configuring Specter Desktop..."
export BTC_RPC_PROTOCOL=http
export BTC_RPC_TYPE="$(yq e '.bitcoind.type' /root/start9/config.yaml)"
export BTC_RPC_USER="$(yq e '.bitcoind.user' /root/start9/config.yaml)"
export BTC_RPC_PASSWORD="$(yq e '.bitcoind.password' /root/start9/config.yaml)"
if [ "$RPC_TYPE" = "internal-proxy" ]; then
	export BTC_RPC_HOST="btc-rpc-proxy.embassy"
	echo "Running on Bitcoin Proxy..."
else
	export BTC_RPC_HOST="bitcoind.embassy"
	echo "Running on Bitcoin Core..."
fi
echo "Starting Specter Desktop..."
python3 -m cryptoadvance.specter server --host specter-desktop.embassy

trap _term SIGTERM
wait -n $specter_desktop_process