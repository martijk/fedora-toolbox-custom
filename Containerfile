FROM registry.fedoraproject.org/fedora-toolbox:39

ARG NAME=fedora-toolbox-custom
ARG BIN_DIR=/usr/local/bin
ARG COMPLETIONS_DIR=/usr/local/share/bash-completion/completions

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=v2.2.1

LABEL name="$NAME" \
      summary="Fedora toolbox container" \
      maintainer="Martijn Kruiten"

ENV EDITOR=nvim

# install repositories
RUN dnf -y install \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install packages
RUN dnf -y upgrade \
  && dnf -y install \
  @development-tools \
  @c-development \
  python3-devel \
  kitty \
  kitty-bash-integration \
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
