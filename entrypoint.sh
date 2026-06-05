#!/usr/bin/env bash
set -euo pipefail

if [ ! -f ./run.sh ]; then
    cp -a /opt/actions-runner/. /actions-runner/
fi

if [ ! -f .runner ]; then
    : "${GITHUB_URL:?GITHUB_URL is required for first-time runner configuration}"
    : "${RUNNER_TOKEN:?RUNNER_TOKEN is required for first-time runner configuration}"

    ./config.sh \
        --url "$GITHUB_URL" \
        --token "$RUNNER_TOKEN" \
        --name "${RUNNER_NAME:-$(hostname)}" \
        --unattended \
        --replace
fi

exec "$@"
