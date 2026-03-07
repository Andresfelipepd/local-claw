FROM ghcr.io/openclaw/openclaw:latest

USER root

RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    ffmpeg \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# instalar clawhub CLI
RUN npm install -g clawhub

WORKDIR /app

EXPOSE 18789

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]