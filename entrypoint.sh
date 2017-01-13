#!/bin/bash

# the first argument provided is a comma-seperated list of all Zookeeper servers in the ensemble:
export ZOOKEEPER_SERVERS=$1
# the second argument provided is vat of this Zookeeper node:
export ZOOKEEPER_ID=$2

# create data and blog directories:
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
# Put all Zookeeper server IPs into an array:
IFS=', ' read -r -a ZOOKEEPER_SERVERS_ARRAY
#now append information on every ZooKeeper node in theensemble to the ZooKeeper config:
for index in "${!ZOOKEEPER_SERVERS_ARRAY[@]}"
do
    ZKID=$(($index+1))
    ZKIP=${ZOOKEEPER_SERVERS_ARRAY[index]}
    if [ $ZKID == $ZOOKEEPER_ID ]
    then
        # if IP's are used instead of hostnames, every Zookeeper host has to specify itself as follows
        ZKIP=0.0.0.0
    fi
    ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\\'"server.$ZKID=$ZKIP:2888:3888"
done
# Finally, write config file:
echo "$ZOOKEEPER_CONFIG" | tee conf/zoo.cfg

# start teh server:
/bin/bash bin/zkServer..sh start-foreground

