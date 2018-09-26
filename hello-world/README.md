# Ballerina


## Install
* Download https://ballerina.io/downloads
* sudo dpkg -i /<ballerina-home>/<ballerina-binary>.deb

which ballerina
```
/usr/bin/ballerina
```

## Hello World Service


hello_world_service.bal
```
import ballerina/http;
import ballerina/log;

service<http:Service> hello bind { port: 9090 } {

    sayHello(endpoint caller, http:Request req) {
        http:Response res = new;

        res.setPayload("Hello, World!");

        caller->respond(res) but { error e => log:printError(
                           "Error sending response", err = e) };
    }
}
```

Run
```
$ ballerina run hello_world_service.bal
ballerina: initiating service(s) in 'hello_world_service.bal'
ballerina: started HTTP/WS endpoint 0.0.0.0:9090

$ curl localhost:9090/hello/sayHello
Hello, World!~/p/ballerina
```

