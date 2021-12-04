#!/bin/bash

echo "Enter your miner address:";
read MINER_ADDRESS

if [ "${MINER_ADDRESS}" == "" ]
then
  MINER_ADDRESS="aleo1h45krnrvfa9z0z3w40u902s8qlpay0ewzlx2z2vhkg9krzegyvxqzmmhlv"
fi

COMMAND="cargo run --release -- --miner ${MINER_ADDRESS} --trial --verbosity 2"

for word in $*;
do
  COMMAND="${COMMAND} ${word}"
done

function exit_node()
{
    echo "Exiting..."
    kill $!
    exit
}

trap exit_node SIGINT

echo "Running miner node..."

while :
do
  echo "Checking for updates..."
  git stash
  STATUS=$(git pull)

  echo "Running the node..."

  if [ "$STATUS" != "Already up to date." ]; then
    cargo clean
  fi
  $COMMAND & sleep 1800; kill -INT $!

  sleep 2;
done
