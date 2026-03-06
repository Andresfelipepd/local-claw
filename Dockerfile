FROM ghcr.io/openclaw/openclaw:latest

USER root

# deps básicas (las que ya usas)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    golang-go \
    build-essential \
    ca-certificates \
    wget \
    file \
    sudo \
    ffmpeg \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install uv

# pnpm global dir
ENV PNPM_HOME=/root/.local/share/pnpm
ENV PATH=$PNPM_HOME:$PATH

RUN mkdir -p $PNPM_HOME

# instalar nvm
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=20

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# instalar node + pnpm
RUN bash -c "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && npm install -g pnpm"

# instalar brew (linuxbrew)
RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# cargar nvm automáticamente
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /root/.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc

WORKDIR /app

EXPOSE 18789

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]
