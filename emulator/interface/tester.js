const HOST = "192.168.43.29";
const PORT = "8080";

function $(id) {
  return document.getElementById(id);
}
function sync() {
  if (ws.readyState == 1) {
    ws.send(format(["update", { o2: $("o2").value, ph: $("ph").value }]));
  }
}
function update(of) {
  $(of + "-label").innerHTML = `${of} : ${$(of).value}`;
}
function format(data) {
  return JSON.stringify(data);
}
let ws = new WebSocket(`ws://${HOST}:${PORT}`);

ws.onopen = (m) => {
  $("state").innerHTML = "Connected ✅";
  $("sync").disabled = false;
  ws.send(format(["register", "device"]));
};
ws.onmessage = (m) => console.log(m.data);
ws.onclose = (m) => {
  $("state").innerHTML = "Disconnected ❌";
  $("sync").disabled = true;
};
ws.onerror = (e) => {
  $("state").innerHTML = "Error ⚠";
  console.log(e);
};
