from flask import Flask, request
import logging
import os
import sys
from datetime import datetime

app = Flask(__name__)
PORT = int(os.environ.get("PORT", 3000))

# ---- Logging setup (stdout, timestamps, levels) ----
root = logging.getLogger()
root.setLevel(logging.INFO)

handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.INFO)
formatter = logging.Formatter(
    "%(asctime)s %(levelname)s %(name)s %(message)s"
)
handler.setFormatter(formatter)

# Avoid duplicate handlers if reloaded
if not root.handlers:
    root.addHandler(handler)
else:
    # replace existing handler formats to be safe
    for h in root.handlers:
        h.setFormatter(formatter)
        h.setLevel(logging.INFO)

# Flask’s own logger uses the root config
app.logger.setLevel(logging.INFO)

@app.before_request
def log_request():
    app.logger.info(
        "request start method=%s path=%s ip=%s ua=\"%s\"",
        request.method, request.path, request.remote_addr, request.user_agent.string
    )

@app.after_request
def log_response(resp):
    app.logger.info(
        "request end method=%s path=%s status=%s length=%s",
        request.method, request.path, resp.status_code, resp.calculate_content_length()
    )
    return resp

@app.route("/")
def hello():
    app.logger.info("hello endpoint hit at %s", datetime.utcnow().isoformat() + "Z")
    return "Hello World from Flask with logging!\n"

@app.route("/healthz")
def health():
    return "ok\n", 200

if __name__ == "__main__":
    # Bind to 0.0.0.0 so it’s reachable in Docker/ECS
    app.run(host="0.0.0.0", port=PORT)
