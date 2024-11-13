FROM debian:bookworm AS base

SHELL ["/bin/bash", "--login", "-c"]

# system deps
RUN apt update && \
    apt install -y \
    libwebkit2gtk-4.1-dev \
    build-essential \
    curl \
    wget \
    file \
    libxdo-dev \
    libssl-dev \
    libayatana-appindicator3-dev \
    librsvg2-dev

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-update-default-toolchain && \
    source $HOME/.cargo/env && rustup install 1.77.2

# node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash && \
    source $HOME/.nvm/nvm.sh && \
    nvm install 22

RUN npm install -g bun

WORKDIR /workspace/src

COPY . .

RUN npm i

RUN npm run tauri build

RUN cp src-tauri/target/release/bundle/deb/*.deb /workspace
