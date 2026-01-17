import http from "http";
import fetch from "node-fetch";

const STREAM_URL = "https://icecast.vrtcdn.be/ketnetradio-high.mp3";

http.createServer(async (req, res) => {
  res.writeHead(200, {
    "Content-Type": "audio/mpeg",
    "Cache-Control": "no-cache",
    "Connection": "keep-alive"
  });

  const response = await fetch(STREAM_URL);
  response.body.pipe(res);
}).listen(process.env.PORT || 8080);
