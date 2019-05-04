import 'simple-css-reset/reset.css';
import '../css/app.css';
import LiveSocket from "phoenix_live_view";

const liveSocket = new LiveSocket("/live");
liveSocket.connect();
