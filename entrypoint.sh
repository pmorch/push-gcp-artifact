#!/bin/bash

function usage {
    if [ ! -z "$1" ]; then
        echo "*Error*: $1" > /dev/stderr
    fi
    echo <<'EOT' > /dev/stderr
docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD/keyfile:/keyfile \
    -e ARTIFACT_LOCATION=europe-west4 \
    push-gcp-artifact \
    europe-west4-docker.pkg.dev/civil-partition-123456/dockerrepo/imagename

NOTE: The final image name contains both ARTIFACT_LOCATION and the project_id
      which is also in the keyfile. This is is not (yet) checked
EOT
    exit 1
}

KEYFILE=/keyfile
if [ ! -f $KEYFILE -o ! -r $KEYFILE ] ; then
    usage "Couldn't read $KEYFILE"
    exit 1
fi

if [ -z "$ARTIFACT_LOCATION"_ ] ; then
    usage "No ARTIFACT_LOCATION"
fi


if [ -z "$1" ] ; then
    usage "No image name"
fi

IMAGE_NAME=$1
shift

# See https://cloud.google.com/artifact-registry/docs/docker/authentication#standalone-helper
docker-credential-gcr configure-docker --registries=$ARTIFACT_LOCATION
cat $KEYFILE | \
    docker login -u _json_key --password-stdin \
        https://${ARTIFACT_LOCATION}-docker.pkg.dev

# echo $IMAGE_NAME ARGS: "$@"
# --quiet coming in docker version 20.03
# https://github.com/docker/cli/pull/2197
# docker push --quiet $IMAGE_NAME
docker push $IMAGE_NAME
