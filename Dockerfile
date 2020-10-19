FROM ubuntu
RUN apt-get update
# RUN apt-get install -y docker.io tmux python
RUN apt-get install -y docker.io tmux
RUN apt-get install -y curl

# This bit comes from
# https://cloud.google.com/artifact-registry/docs/docker/authentication#standalone-helper
ARG VERSION=2.0.0
# or "darwin" for OSX, "windows" for Windows.
ARG OS=linux
# or "386" for 32-bit OSs
ARG ARCH=amd64

RUN curl -fsSL "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${VERSION}/docker-credential-gcr_${OS}_${ARCH}-${VERSION}.tar.gz" \
    | tar xz --to-stdout ./docker-credential-gcr \
    > /usr/bin/docker-credential-gcr && chmod +x /usr/bin/docker-credential-gcr
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD []
