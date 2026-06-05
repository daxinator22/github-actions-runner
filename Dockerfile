FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y \
        ca-certificates \
        curl \
        git \
        jq \
        libicu72 \
        libssl3 \
    && rm -rf /var/lib/apt/lists/

RUN useradd --create-home --shell /bin/bash runner \
    && mkdir /actions-runner /opt/actions-runner \
    && chown runner:runner /actions-runner /opt/actions-runner

WORKDIR /opt/actions-runner

USER runner

RUN curl -o actions-runner-linux-x64-2.334.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.334.0/actions-runner-linux-x64-2.334.0.tar.gz && \
	tar xzf ./actions-runner-linux-x64-2.334.0.tar.gz && \
	rm actions-runner-linux-x64-2.334.0.tar.gz

USER root

COPY --chown=runner:runner entrypoint.sh /usr/local/bin/actions-runner-entrypoint
RUN chmod +x /usr/local/bin/actions-runner-entrypoint

WORKDIR /actions-runner

USER runner

ENTRYPOINT ["/usr/local/bin/actions-runner-entrypoint"]
CMD ["./run.sh"]
