from flask import Flask
import os

app = Flask(__name__)
PORT = int(os.environ.get("PORT", 3000))

@app.route("/")
def hello():
    return "Hello World from Flask!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)
