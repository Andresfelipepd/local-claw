FROM ghcr.io/openclaw/openclaw:latest

USER root

RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    python3 \
    file \
    procps \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

USER node

# npm
RUN mkdir -p /home/node/.npm-global
RUN npm config set prefix '/home/node/.npm-global'
ENV PATH="/home/node/.npm-global/bin:${PATH}"

# go
RUN mkdir -p /home/node/go
ENV GOPATH="/home/node/go"
ENV PATH="$GOPATH/bin:${PATH}"

RUN npm install -g clawhub

# brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# uv 
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/home/node/.local/bin:${PATH}"

WORKDIR /app

EXPOSE 18789

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]