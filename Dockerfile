FROM ghcr.io/openclaw/openclaw:latest

USER root

RUN apt-get update

USER node

RUN mkdir -p /home/node/.npm-global
RUN npm config set prefix '/home/node/.npm-global'
ENV PATH="/home/node/.npm-global/bin:${PATH}"

RUN npm install -g clawhub

WORKDIR /app

EXPOSE 18789

CMD ["node", "dist/index.js", "gateway", "--bind", "lan", "--port", "18789"]