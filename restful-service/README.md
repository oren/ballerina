# Restful Service

order_mgt_service.bal
```
import ballerina/http;

endpoint http:Listener listener {
    port:9090
};

// Order management is done using an in memory map.
// Add some sample orders to 'ordersMap' at startup.
map<json> ordersMap;

// RESTful service.
@http:ServiceConfig { basePath: "/ordermgt" }
service<http:Service> orderMgt bind listener {

    // Resource that handles the HTTP GET requests that are directed to a specific
    // order using path '/order/<orderId>'.
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/order/{orderId}"
    }
    findOrder(endpoint client, http:Request req, string orderId) {
        // Find the requested order from the map and retrieve it in JSON format.
        json? payload = ordersMap[orderId];
        http:Response response;
        if (payload == null) {
            payload = "Order : " + orderId + " cannot be found.";
        }

        // Set the JSON payload in the outgoing response message.
        response.setJsonPayload(untaint payload);

        // Send response to the client.
        _ = client->respond(response);
    }

    // Resource that handles the HTTP POST requests that are directed to the path
    // '/order' to create a new Order.
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/order"
    }
    addOrder(endpoint client, http:Request req) {
        json orderReq = check req.getJsonPayload();
        string orderId = orderReq.Order.ID.toString();
        ordersMap[orderId] = orderReq;

        // Create response message.
        json payload = { status: "Order Created.", orderId: orderId };
        http:Response response;
        response.setJsonPayload(untaint payload);

        // Set 201 Created status code in the response message.
        response.statusCode = 201;
        // Set 'Location' header in the response message.
        // This can be used by the client to locate the newly added order.
        response.setHeader("Location", "http://localhost:9090/ordermgt/order/" +
                orderId);

        // Send response to the client.
        _ = client->respond(response);
    }

    // Resource that handles the HTTP PUT requests that are directed to the path
    // '/order/<orderId>' to update an existing Order.
    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/order/{orderId}"
    }
    updateOrder(endpoint client, http:Request req, string orderId) {
        json updatedOrder = check req.getJsonPayload();

        // Find the order that needs to be updated and retrieve it in JSON format.
        json existingOrder = ordersMap[orderId];

        // Updating existing order with the attributes of the updated order.
        if (existingOrder != null) {
            existingOrder.Order.Name = updatedOrder.Order.Name;
            existingOrder.Order.Description = updatedOrder.Order.Description;
            ordersMap[orderId] = existingOrder;
        } else {
            existingOrder = "Order : " + orderId + " cannot be found.";
        }

        http:Response response;
        // Set the JSON payload to the outgoing response message to the client.
        response.setJsonPayload(untaint existingOrder);
        // Send response to the client.
        _ = client->respond(response);
    }

    // Resource that handles the HTTP DELETE requests, which are directed to the path
    // '/order/<orderId>' to delete an existing Order.
    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/order/{orderId}"
    }
    cancelOrder(endpoint client, http:Request req, string orderId) {
        http:Response response;
        // Remove the requested order from the map.
        _ = ordersMap.remove(orderId);

        json payload = "Order : " + orderId + " removed.";
        // Set a generated payload with order status.
        response.setJsonPayload(untaint payload);

        // Send response to the client.
        _ = client->respond(response);
    }
}
```

Run
```
ballerina run restful_service
```

Use
```
 curl -v -X POST -d '{ "Order": { "ID": "100500", "Name": "XYZ", "Description": "Sample order."}}' "http://localhost:9090/ordermgt/order" -H "Content-Type:application/json"
 Output :
< HTTP/1.1 201 Created
< Content-Type: application/json
< Location: http://localhost:9090/ordermgt/order/100500
< content-length: 46
< server: ballerina/0.981.0

{"status":"Order Created.","orderId":"100500"}
```

Test
```
ballerina test
```
