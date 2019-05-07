import 'simple-css-reset/reset.css';
import '../css/app.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'phoenix';
import 'phoenix_html';
import LiveSocket from 'phoenix_live_view';

const liveSocket = new LiveSocket('/live');
liveSocket.connect();
