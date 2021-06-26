const WebSocket = require("ws");

const ws = new WebSocket("wss://purifier-websocket.herokuapp.com");

ws.on("open", function open() {
  ws.send(JSON.stringify(["register", "logger"]));
  console.log("Logger Active");
});

ws.on("message", function incoming(data) {
  console.log(data);
});

ws.on("close", function close() {
  console.log("Closed");
});

ws.on("error", function errror(e) {
  console.log(e);
});
