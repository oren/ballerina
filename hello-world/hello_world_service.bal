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
