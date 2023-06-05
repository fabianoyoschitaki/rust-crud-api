# We will use a multi-stage build. We will have:
# a build stage: to build the Rust app
# a production stage: to run the Rust app

# BUILD STAGE
FROM rust:1.69-buster as builder
WORKDIR /app
# Accept the build argument
ARG DATABASE_URL_ARG
ARG TEST_ARG
# Make sure to use the ARG in ENV
ENV DATABASE_URL=$DATABASE_URL_ARG
ENV TEST=$TEST_ARG
# Copy the source code
COPY . .
# Build the application
RUN cargo build --release

# PRODUCTION STAGE
FROM debian:buster-slim
WORKDIR /usr/local/bin

ARG PROD_STAGE_TEST_ARG
ENV PROD_STAGE_TEST_ENV=$PROD_STAGE_TEST_ARG

COPY --from=builder /app/target/release/rust-crud-api .
CMD ["./rust-crud-api"] 

