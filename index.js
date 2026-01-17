import http from "http";
import fetch from "node-fetch";

const STREAM_URL = "https://icecast.vrtcdn.be/ketnetradio-high.mp3";

http
  .createServer(async (req, res) => {
    // simple health check
    if (req.url === "/health") {
      res.writeHead(200, { "Content-Type": "text/plain" });
      return res.end("ok");
    }

    res.writeHead(200, {
      "Content-Type": "audio/mpeg",
      "Cache-Control": "no-cache",
      Connection: "keep-alive",
    });

    try {
      const upstream = await fetch(STREAM_URL);
      if (!upstream.ok || !upstream.body) throw new Error(`Upstream ${upstream.status}`);

      upstream.body.pipe(res);

      upstream.body.on("error", () => {
        try { res.end(); } catch {}
      });

      req.on("close", () => {
        try { upstream.body.destroy(); } catch {}
      });
    } catch (e) {
      res.statusCode = 502;
      res.end("Upstream stream error");
    }
  })
  .listen(process.env.PORT || 8080);
