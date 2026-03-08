FROM ghcr.io/openclaw/openclaw:latest

USER root

# paquetes base
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    ca-certificates \
    wget \
    file \
    sudo \
    ffmpeg \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# instalar Go
RUN wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz \
 && rm -rf /usr/local/go \
 && tar -C /usr/local -xzf go1.22.5.linux-amd64.tar.gz \
 && rm go1.22.5.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:$PATH"

# instalar uv (python package manager moderno)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/root/.local/bin:$PATH"

# instalar brew
RUN git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew

ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# ---------- CONFIGURACIÓN PARA QUE LA UI PUEDA INSTALAR SKILLS ----------

# npm global dir sin permisos root
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global

# pnpm global dir
ENV PNPM_HOME=/home/node/.local/share/pnpm

# PATH final
ENV PATH="/home/node/.npm-global/bin:/home/node/.local/share/pnpm:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/usr/local/go/bin:/root/.local/bin:$PATH"

# crear carpetas necesarias
RUN mkdir -p /home/node/.npm-global \
 && mkdir -p /home/node/.local/share/pnpm \
 && chown -R node:node /home/node

# instalar clawhub global
RUN npm install -g clawhub

WORKDIR /app

EXPOSE 18789

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]