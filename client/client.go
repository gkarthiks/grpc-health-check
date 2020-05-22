package main

import (
	"context"
	"github.com/sirupsen/logrus"
	"google.golang.org/grpc"
	"grpc-health-check/proto"
	"io"
)

func main() {
	serverAddr := ":5000"
	conn, err := grpc.Dial(serverAddr, grpc.WithInsecure())
	if err != nil {
		logrus.Fatalf("Couldn't dial server at %s", serverAddr)
	}
	defer conn.Close()
	helloClient := proto.NewGreetServiceClient(conn)

	stream, err := helloClient.Hello(context.Background(), &proto.HelloRequest{
		Hello: "World",
	})

	for {
		streamData, err := stream.Recv()
		if err == io.EOF {
			break
		}
		if err != nil {
			logrus.Fatalf("%v.Greet = _, %v", helloClient, err)
		}
		logrus.Println(streamData)
	}

	logrus.Println("Doing a health check on the server")

}
