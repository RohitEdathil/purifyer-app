const HOST = "192.168.17.32";
const PORT = "8080";
var current_hours = 4;
var current_minutes = 0;
var error = "no-error";
let ws;
function $(id) {
  return document.getElementById(id);
}
function sync() {
  if (ws.readyState == 1) {
    ws.send(format(["update", { o2: $("o2").value, ph: $("ph").value }]));
  }
}
function send_time() {
  ws.send(format(["time", { hours: current_hours, minutes: current_minutes }]));
}
function send_error() {
  ws.send(format(["error", error]));
}
function setTime(hours, minutes) {
  current_hours = parseInt(hours);
  current_minutes = parseInt(minutes);
  $("from").innerHTML = `[H: ${current_hours} | M: ${current_minutes}]`;
  $("to").innerHTML = `[H: ${current_hours + 18} | M: ${current_minutes}]`;
  $("in").style.left = `${
    ((current_hours * 60 + current_minutes) * 150) / 360
  }px`;
}
function set(data) {
  switch (data[1]) {
    case "time":
      setTime(data[2]["hours"], data[2]["minutes"]);
      break;

    default:
      break;
  }
}
function update(of) {
  $(of + "-label").innerHTML = `${of} : ${$(of).value}`;
}

function format(data) {
  return JSON.stringify(data);
}
function request(data) {
  switch (data[1]) {
    case "all":
      sync();
      send_error();
      send_time();
      break;
    case "update":
      sync();
      break;
    case "time":
      send_time();
      break;
    case "error":
      send_error();
      break;
    default:
      break;
  }
}
function handle(message) {
  const data = JSON.parse(message.data);
  const command_map = {
    request: request,
    set: set,
  };
  command_map[data[0]](data);
}
function connect() {
  ws = new WebSocket(`ws://${HOST}:${PORT}`);
  ws.onopen = (m) => {
    $("state").innerHTML = "Connected ✅";
    $("sync").disabled = false;
    ws.send(format(["register", "device"]));
  };
  ws.onmessage = (m) => handle(m);
  ws.onclose = (m) => {
    $("state").innerHTML = "Disconnected ❌";
    $("sync").disabled = true;
    setTimeout(() => {
      $("state").innerHTML = "Connecting ⌚";
      connect();
    }, 3000);
  };
  ws.onerror = (e) => {
    $("state").innerHTML = "Error ⚠";
    console.log(e);
  };
}
connect();
setTime(current_hours, current_minutes);
