FROM golang:alpine3.11 as build
RUN mkdir -p /usr/local/src
COPY . /usr/local/src
WORKDIR /usr/local/src/
#RUN cd server && go build .
RUN cd server && env CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -a --installsuffix cgo -v -tags netgo -ldflags '-extldflags "-static"' .
RUN GRPC_HEALTH_PROBE_VERSION=v0.3.2 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
CMD ./server/server
