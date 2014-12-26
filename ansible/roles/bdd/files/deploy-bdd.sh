#!/bin/sh

BLUE_PORT=9001
GREEN_PORT=9002
CURRENT_COLOR=$(etcdctl get /bdd/color)
if [ "$CURRENT_COLOR" = "" ]; then
  CURRENT_COLOR="green"
fi
if [ "$CURRENT_COLOR" = "blue" ]; then
  PORT=$GREEN_PORT
  COLOR="green"
else
  PORT=$BLUE_PORT
  COLOR="blue"
fi

echo "Starting $COLOR deployment on port $PORT"
set +e
docker stop bdd-$COLOR
docker rm bdd-$COLOR
set -e
docker pull vfarcic/bdd
docker run -d --name bdd-$COLOR -p $PORT:9000 vfarcic/bdd
sleep 5
etcdctl set /bdd/color $COLOR
etcdctl set /bdd/port $PORT
etcdctl set /bdd/$COLOR/port $PORT
etcdctl set /bdd/$COLOR/status running
confd -onetime -backend etcd -node 127.0.0.1:4001
echo "Stopping $CURRENT_COLOR deployment"
sleep 60
docker stop bdd-$CURRENT_COLOR
etcdctl set /bdd/$CURRENT_COLOR/status stopped