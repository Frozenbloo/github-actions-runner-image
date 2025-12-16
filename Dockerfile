FROM ubuntu:24.04

ARG RUNNER_VERSION="2.330.0"

# Disable interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -y && apt upgrade -y && useradd -m docker

RUN apt install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip 

RUN cd /home/docker && mkdir github-actions-runner && cd github-actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

RUN chown -R docker ~docker && /home/docker/github-actions-runner/bin/installdependencies.sh

COPY start.sh /home/docker/github-actions-runner/start.sh

RUN chown docker /home/docker/github-actions-runner/start.sh && chmod +x /home/docker/github-actions-runner/start.sh

WORKDIR /home/docker/github-actions-runner

USER docker

ENTRYPOINT [ "./start.sh" ]