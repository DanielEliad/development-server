export DOCKER_API_VERSION=1.22
export DOCKER_HOST=tcp://terminal.local:2375
echo "Deleting old instance..." && docker-compose down # delete any existing instances
echo "Rebuilding instace..." && docker-compose build # rebuild the new version
echo "starting the new instace..." && docker-compose up -d # start the new version in detached mode
