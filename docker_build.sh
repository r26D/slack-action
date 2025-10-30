#!/bin/bash


#Push to github
docker build -t "ghcr.io/r26d/slack-action/slack-action:v${1}" .
docker build -t "ghcr.io/r26d/slack-action/slack-action:latest" .
docker push "ghcr.io/r26d/slack-action/slack-action:latest"
docker push "ghcr.io/r26d/slack-action/slack-action:v${1}"

##Push to docker
docker build -t "delmendo/slack-action:v${1}" .
docker build -t delmendo/slack-action:latest .
docker push delmendo/slack-action:latest
docker push "delmendo/slack-action:v${1}"