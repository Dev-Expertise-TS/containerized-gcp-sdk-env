FROM google/cloud-sdk:debian_component_based

# 필요한 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    python3-pip \
    nodejs \
    npm \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# code-server 설치 (VS Code Server)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 작업 디렉토리 생성
WORKDIR /workspace

# 환경 변수 설정
ENV SHELL=/bin/bash

# code-server 설정 디렉토리
RUN mkdir -p /root/.config/code-server
COPY code-server-config.yaml /root/.config/code-server/config.yaml

# code-server 시작 명령
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--user-data-dir", "/workspace/.vscode-server", "--auth", "none", "/workspace"]
