#!/bin/bash

#script from https://github.com/gten/docker-zookeeper-cluster

# the first argument provided is a comma-seperated list of all Zookeeper servers in the ensemble:
export ZOOKEEPER_SERVERS
# the second argument provided is vat of this Zookeeper node:
export ZOOKEEPER_ID

# create data directory
mkdir -p $dataDir
mkdir -p $dataLogDir

# create myID file:
echo "$ZOOKEEPER_ID" | tee $dataDir/myid

# now build the ZooKeeper configuration file:
ZOOKEEPER_CONFIG=
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"tickTime=$tickTime"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"dataDir=$dataDir"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"dataLogDir=$dataLogDir"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"clientPort=$clientPort"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"initLimit=$initLimit"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"syncLimit=$syncLimit"
# Put all Zookeeper server hostnames into an array:
IFS=',' read -r -a ZOOKEEPER_SERVERS_ARRAY <<<"$ZOOKEEPER_SERVERS"

for index in "${!ZOOKEEPER_SERVERS_ARRAY[@]}"
do
    ZKID=$(($index+1))
    echo "ZKID is $ZKID"
    echo "ZOOKEEPER_ID is $ZOOKEEPER_ID"
    ZKIP=${ZOOKEEPER_SERVERS_ARRAY[index]}
    ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"server.$ZKID=$ZKIP:2888:3888"
    echo "ZOOKEEPER_CONFIG is $ZOOKEEPER_CONFIG"
done
# Finally, write config file:
echo "$ZOOKEEPER_CONFIG" | tee conf/zoo.cfg

# start teh server:
/bin/bash bin/zkServer.sh start-foreground

