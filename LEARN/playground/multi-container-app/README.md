🔧 Step 1: Docker Compose with Two Containers (Frontend + Backend)

We’ll simulate a real app architecture:
	•	Frontend: simple HTML served by NGINX
	•	Backend: a basic Python API (using Flask)

multi-container-app/
├── backend/
│   ├── app.py
│   └── Dockerfile
├── frontend/
│   ├── index.html
│   └── Dockerfile
├── docker-compose.yml

🔙 backend/app.py

from flask import Flask, jsonify
app = Flask(__name__)

@app.route("/api")
def hello():
    return jsonify(message="Hello from the backend!")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

backend/Dockerfile

FROM python:3.10-slim
WORKDIR /app
COPY app.py .
RUN pip install flask
CMD ["python", "app.py"]

frontend/index.html

<!DOCTYPE html>
<html>
<head><title>Frontend</title></head>
<body>
  <h1>Hello from the Frontend</h1>
  <button onclick="fetch('/api').then(r => r.json()).then(d => alert(d.message))">Ping Backend</button>
</body>
</html>

frontend/default.conf

server {
    listen 80;

    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /api {
        proxy_pass http://backend:5000/api;
    }
}

frontend/Dockerfile

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY default.conf /etc/nginx/conf.d/default.conf

docker-compose up --build -d

✅ Test It

Go to: http://localhost:8080
Click the button → It should now call backend:5000/api through NGINX proxy and alert:
“Hello from the backend!”