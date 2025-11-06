# Character-Counter-Application
“Full stack Character Count Application (Frontend + Backend + Kubernetes deployment)”

Launch EC2 — create Ubuntu instance, attach a security group allowing SSH (22) and NodePort range (30000–32767).

SSH to EC2 — connect with your .pem key: ssh -i key.pem ubuntu@<EC2-IP>.

Install Docker — add Docker repo, install docker-ce, enable/start service, add user to docker group, re-login.

Install Kubernetes — install kubeadm/kubelet/kubectl (or use your existing cluster), ensure kubectl get nodes returns Ready.

Create project dirs — mkdir -p ~/char-count/{backend,frontend,k8s} to keep code organized.

Write backend — Flask API in backend/app.py with /count POST returning {"count": len(name)}.

Dockerize backend — backend/Dockerfile based on python:3.9-slim, copy app.py, pip install flask, expose 5000, run python app.py.

Build+push backend image — docker build -t <user>/char-backend:v1 . then docker push <user>/char-backend:v1.

Write frontend — frontend/index.html with input + JS fetch("http://char-backend.default.svc.cluster.local:5000/count").

Dockerize frontend — frontend/Dockerfile using nginx:alpine, copy index.html to /usr/share/nginx/html, expose 80.

Build+push frontend image — docker build -t <user>/char-frontend:v1 . then docker push <user>/char-frontend:v1.

Backend Deployment — in k8s/backend.yaml create Deployment (1 replica, containerPort 5000) for image <user>/char-backend:v1.

Backend Service — in same file create Service type ClusterIP on port 5000 to keep backend internal.

Frontend Deployment — in k8s/frontend.yaml create Deployment (1 replica, containerPort 80) for image <user>/char-frontend:v1.

Frontend Service — in same file create Service type NodePort (port 80 → nodePort 30007) to expose UI externally.

Apply manifests — kubectl apply -f k8s/backend.yaml && kubectl apply -f k8s/frontend.yaml to create all objects.

Verify pods — kubectl get pods should show both char-backend and char-frontend as Running.

Verify services — kubectl get svc should show char-frontend on 80:30007/TCP and char-backend on 5000/TCP.

Open app — browse http://<EC2-PUBLIC-IP>:30007 to load UI and count characters via backend.
