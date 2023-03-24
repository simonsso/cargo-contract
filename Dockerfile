FROM rust:1.68-bullseye as builder
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /builds
ARG target=x86_64-unknown-linux-gnu
RUN apt-get update && apt-get install -qy libssl-dev pkg-config
RUN rustup target add ${target}
RUN rustup target add wasm32-unknown-unknown
RUN rustup component add rust-src --toolchain 1.68.0-${target}
RUN cargo install cargo-dylint
RUN cargo install dylint-link
RUN cargo install cargo-contract --force --locked --version 1.5.1
RUN find / | grep cargo-contract 
COPY . .

FROM rust:1.68-slim-bullseye as runtime
ARG bin=chain-executor
ARG target=x86_64-unknown-linux-gnu	
ARG profile=release
RUN apt-get update && apt-get upgrade -qy && apt-get -qy install libssl-dev
RUN install -d /usr/local/cargo/bin
RUN cargo install cargo-dylint
COPY --from=builder /usr/local/cargo/ /usr/local/cargo/
COPY --from=builder /usr/local/cargo/bin/cargo-dylint /bin/
WORKDIR /github/workspace
