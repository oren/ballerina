## Run docker daemon
dockerd

## Execute Docker image
docker run hello-world

## List Docker CLI commands
docker
docker container --help

## Display Docker version and info
docker --version
docker version
docker info

## Execute Docker image
docker run hello-world

## List Docker images
docker image ls

## List Docker containers (running, all, all in quiet mode)
docker container ls
docker container ls --all
docker container ls -aq

## Remove images
* removes any stopped containers and all unused images (not just dangling images)
docker system prune -a
