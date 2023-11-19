FROM registry.fedoraproject.org/fedora-toolbox:latest

ARG NAME=toolbox
ARG BIN_DIR=/usr/local/bin
ARG COMPLETIONS_DIR=/usr/local/share/bash-completion/completions

ARG COSIGN_VERSION=v2.0.2

LABEL name="$NAME" \
      summary="Fedora toolbox container" \
      maintainer="Martijn Kruiten"

ENV EDITOR=nvim

# Install packages
RUN dnf -y upgrade \
  && dnf -y install \
  @development-tools \
  @c-development \
  python3-devel \
  kitty \
  tmux \
  mosh \
  npm \
  cargo \
  ripgrep \
  fd-find \
  ffmpeg \
  htop \
  neovim \
  && dnf clean all

# Create bash-completion dir
RUN mkdir -p "${COMPLETIONS_DIR}"

# Install cosign
RUN curl -Lo "${BIN_DIR}/cosign" \
  "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64" \
  && chmod +x "${BIN_DIR}/cosign" \
  && cosign completion bash > "${COMPLETIONS_DIR}/cosign"
