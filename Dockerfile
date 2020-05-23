FROM golang:1.14 as builder
WORKDIR /usr/local/src/
COPY . ./
RUN CGO_ENABLED=0 go build -o ./hello-server ./server
# Not building the client program
RUN GRPC_HEALTH_PROBE_VERSION=v0.3.2 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe

FROM gcr.io/distroless/static
COPY --from=builder /usr/local/src/hello-server /hello-server
COPY --from=builder /bin/grpc_health_probe ./grpc_health_probe
CMD ["/hello-server"]
