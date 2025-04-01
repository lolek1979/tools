# 🚀 Terraform Kubernetes Deployment on Minikube

This project demonstrates how to deploy a multi-container (frontend + backend) application to a **local Minikube cluster** using **Terraform**.

## 📦 Project Structure

terraform-k8s/
├── main.tf
├── variables.tf (optional)
├── outputs.tf  (optional)
└── README.md

## 🧱 Components Deployed

- **Backend Deployment** (Flask app)
- **Frontend Deployment** (NGINX)
- **Services** to expose both
- Frontend available via **NodePort**

---

## 🛠️ Prerequisites

- [Terraform](https://www.terraform.io/downloads)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://www.docker.com/) (used to build images)

---

## ⚙️ Setup Instructions

### 1️⃣ Start Minikube

```bash
minikube start

2️⃣ Use Minikube’s Docker Engine

eval $(minikube docker-env)

3️⃣ Build Docker Images Inside Minikube

docker build -t multi-container-app-backend:latest ./backend
docker build -t multi-container-app-frontend:latest ./frontend

4️⃣ Deploy with Terraform

terraform init
terraform apply

🌐 Access the Application

minikube service frontend

🧹 Tear Down

terraform destroy
minikube stop