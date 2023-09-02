# gRPC        
Home [Link](https://grpc.io/)         
### Protocol Buffers         
Home [Link](https://protobuf.dev/)        
Latest [Link](https://github.com/protocolbuffers/protobuf/releases)       
```
protoc --version
```
### Go plugins       
Install the protocol compiler plugins for Go using the following commands:         
```
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
```
Update your PATH so that the protoc compiler can find the plugins:       
```
export PATH="$PATH:$(go env GOPATH)/bin"
```

###   
define a service in a .proto file, pen helloworld/helloworld.proto and add a new SayHelloAgain() method, with the same request and response types:   
```
syntax = "proto3";

option go_package = "/github.com/helloworld";

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
  // Sends another greeting
  rpc SayHelloAgain (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```
Regenerate gRPC code         
```
protoc --go_out=. --go_opt=paths=source_relative --go-grpc_out=. --go-grpc_opt=paths=source_relative helloworld/helloworld.proto
```

