#!/bin/sh

echo "Setting variables and deciding whether to do blue or green deployment"
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

echo "Stopping and removing existing containers"
set +e
docker stop bdd-$COLOR
docker rm bdd-$COLOR
docker stop bdd-runner-phantomjs
docker rm bdd-runner-phantomjs

echo "Starting $COLOR deployment on port $PORT"
set -e
docker pull vfarcic/bdd
docker run -d --name bdd-$COLOR -p $PORT:9000 vfarcic/bdd

echo "Testing $COLOR deployment on port $PORT"
docker pull vfarcic/bdd-runner-phantomjs
docker run -t --rm --name bdd-runner-phantomjs vfarcic/bdd-runner-phantomjs \
  --story_path data/stories/tcbdd/stories/storyEditorForm.story \
  --composites_path /opt/bdd/composites/TcBddComposites.groovy \
  -P url=http://172.17.42.1:$PORT -P widthHeight=1024,768

echo "Storing new release information and update nginx"
etcdctl set /bdd/color $COLOR
etcdctl set /bdd/port $PORT
etcdctl set /bdd/$COLOR/port $PORT
etcdctl set /bdd/$COLOR/status running
confd -onetime -backend etcd -node 127.0.0.1:4001

echo "Stopping $CURRENT_COLOR deployment"
sleep 10
docker stop bdd-$CURRENT_COLOR
etcdctl set /bdd/$CURRENT_COLOR/status stopped