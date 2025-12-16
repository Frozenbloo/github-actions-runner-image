#!/bin/bash

set -e

# Validate required environment variables
if [ -z "${REPO}" ] || [ -z "${TOKEN}" ]; then
    echo "Error: REPO and TOKEN environment variables must be set"
    echo "Usage: docker run -e REPO=owner/repo -e TOKEN=your_token ..."
    exit 1
fi

echo "Getting registration token for repository: ${REPO}"

echo "Configuring runner..."
./config.sh --url https://github.com/${REPO} --token ${TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!