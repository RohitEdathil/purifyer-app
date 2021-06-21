const HOST = "192.168.43.29";
const PORT = "8080";

function $(id) {
  return document.getElementById(id);
}

let ws = new WebSocket(`ws://${HOST}:${PORT}`);

ws.onopen = (m) => console.log("Connected");
ws.onmessage = (m) => console.log(m.data);
ws.onclose = (m) => console.log("Closed");
ws.onerror = (e) => console.log(e);
