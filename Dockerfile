FROM ruby:3.2

# Defaults and user
ARG USER=app
ARG WORKDIR=/usr/local/${USER}
RUN useradd --create-home --home-dir ${WORKDIR} \
    --shell /bin/bash \
    ${USER}
WORKDIR ${WORKDIR}

# Install ruby deps
COPY Gemfile ./
RUN bundle install

# Install pre-commit and its deps for devcontainer
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
    pre-commit \
    # for pre-commit
    git \
    # for markdownlint
    npm \
    && \
    apt-get clean

# User change
USER ${USER}

# Install pre-commit for devcontainer
COPY --chown=${USER}:${USER} .git/ .git/
COPY --chown=${USER}:${USER} .pre-commit-config.yaml ./
RUN pre-commit install-hooks

# Copy content
COPY --chown=${USER}:${USER} ./ ./


CMD ["bundle", "exec", "jekyll", "serve"]
