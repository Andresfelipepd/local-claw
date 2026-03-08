FROM ghcr.io/openclaw/openclaw:latest

USER root

RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    python3 \
    file \
    procps \
    && rm -rf /var/lib/apt/lists/*

# install Go
RUN curl -L https://go.dev/dl/go1.23.6.linux-amd64.tar.gz -o /tmp/go.tar.gz \
 && rm -rf /usr/local/go \
 && tar -C /usr/local -xzf /tmp/go.tar.gz \
 && rm /tmp/go.tar.gz

# prepare linuxbrew
RUN mkdir -p /home/linuxbrew/.linuxbrew \
 && chown -R node:node /home/linuxbrew

USER node

# npm
RUN mkdir -p /home/node/.npm-global
RUN npm config set prefix '/home/node/.npm-global'

# go workspace
RUN mkdir -p /home/node/go

# uv location
RUN mkdir -p /home/node/.local/bin

# PATH global
ENV GOPATH="/home/node/go"
ENV PATH="/usr/local/go/bin:/home/node/go/bin:/home/node/.npm-global/bin:/home/node/.local/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

RUN npm install -g clawhub

# brew
ENV NONINTERACTIVE=1
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

WORKDIR /app

EXPOSE 18789

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]