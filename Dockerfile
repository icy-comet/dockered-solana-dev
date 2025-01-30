FROM ubuntu:24.04
SHELL ["/bin/bash", "-l", "-c"]

# avoid menu configs on pkg updates if any
ENV DEBIAN_FRONTEND=noninteractive

# install dependencies
RUN apt update && apt upgrade -y && apt install -y build-essential pkg-config libudev-dev llvm libclang-dev protobuf-compiler libssl-dev curl locales git

# define proper locale
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

# add non-root user
RUN useradd -ms /bin/bash apprunner
USER apprunner
WORKDIR /home/apprunner

# install nodejs
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash && source .nvm/nvm.sh && nvm install --lts

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

# install solana CLI
RUN curl -sSfL https://release.anza.xyz/stable/install | bash

# install anchor
RUN cargo install --git https://github.com/coral-xyz/anchor avm --force && avm install latest && avm use latest

CMD [ "sleep", "infinity" ]