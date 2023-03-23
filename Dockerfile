FROM rust:1.68-bullseye as builder
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /builds
ARG target=x86_64-unknown-linux-gnu
RUN apt-get update && apt-get install -qy libssl-dev pkg-config
RUN rustup target add ${target}
RUN rustup target add wasm32-unknown-unknown
RUN cargo install cargo-dylint dylint-link
RUN cargo install cargo-contract --force --locked
RUN find / | grep cargo-contract 
COPY . .

FROM rust:1.68-slim-bullseye as runtime
ARG bin=chain-executor
ARG target=x86_64-unknown-linux-gnu	
ARG profile=release
RUN apt-get update && apt-get upgrade -qy && apt-get -qy install libssl-dev
RUN install -d /usr/local/cargo/bin
COPY --from=builder /usr/local/cargo/bin/* /usr/local/cargo/bin/
WORKDIR /github/workspace
