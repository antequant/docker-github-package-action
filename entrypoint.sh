#!/bin/sh

set -e
set -o errexit

echo "$INPUT_DOCKER_PASSWORD" | docker login "$INPUT_DOCKER_SERVER" -u "${INPUT_DOCKER_USERNAME:-$GITHUB_ACTOR}" --password-stdin

REPO_NAME=$(basename "$GITHUB_REPOSITORY")
IMAGE_NAME="${INPUT_IMAGE_NAME:-$REPO_NAME}"

REPO_OWNER=$(dirname "$GITHUB_REPOSITORY")
IMAGE_PATH="${INPUT_IMAGE_PATH:-$REPO_OWNER}"

IMAGE_ID="docker.pkg.github.com/$IMAGE_PATH/$IMAGE_NAME"

INFERRED_IMAGE_TAG=$(basename "$GITHUB_REF")
if [ "$INFERRED_IMAGE_TAG" = "master" ]
then
    INFERRED_IMAGE_TAG=latest
fi

IMAGE_TAG="${INPUT_IMAGE_TAG:-$INFERRED_IMAGE_TAG}"

docker build -t "$IMAGE_ID:$IMAGE_TAG" .
docker push "$IMAGE_ID:$IMAGE_TAG"