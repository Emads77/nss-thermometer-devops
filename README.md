
# 📊 NSS Thermometer DevOps

**Automated deployment of the NSS Thermometer app using Docker, Terraform, and GitLab CI/CD.**

---

##  Project Overview

The **NSS Thermometer** is a cloud-hosted application that displays the National Student Survey (NSS) stretch goal progress. This project focuses on:

* Containerizing the **backend (Laravel + PostgreSQL)** and **frontend (static site)**.
* Automating infrastructure creation in AWS using **Terraform**.
* Setting up **GitLab CI/CD** pipelines for:

  * Backend & frontend build & test.
  * Docker image builds & pushes.
  * Automatic deployment of the backend on EC2 and the frontend via **GitLab Pages**.
* Implementing **high availability** using an **Auto Scaling Group** and a **Load Balancer.**

---

##  Tech Stack

* **Terraform** (Infrastructure as Code)
* **Docker & Docker Compose**
* **AWS**: EC2, RDS (Postgres), ALB, ASG, VPC
* **GitLab CI/CD & GitLab Pages**
* **Laravel (PHP Backend)**
* **NodeJS (Frontend build system)**

---



## ✅ How It Works

1️⃣ **Terraform (`infra` folder):**

* Provisions:

  * VPC with public & private subnets.
  * RDS PostgreSQL (private subnets).
  * EC2 Auto Scaling Group (private subnets).
  * ALB (public subnets) routing traffic to EC2 instances.

2️⃣ **Backend:**

* Laravel + Postgres.
* Dockerized & built via GitLab CI.
* Deployed automatically on EC2 via SSH & Docker.

3️⃣ **Frontend:**

* Built using Node/NPM.
* **Deployed automatically to GitLab Pages** for public access.

4️⃣ **Seeding Script:**

* `add_data.sh` reads a `data.md` file and seeds the backend API using `curl`.

---

## 🔁 CI/CD Pipeline

| Stage            | Description                                              |
| ---------------- | -------------------------------------------------------- |
| `backend`        | Installs dependencies, runs migrations, runs tests.      |
| `frontend`       | Builds the frontend.                                     |
| `docker-build`   | Builds & pushes backend Docker image to GitLab Registry. |
| `deploy-backend` | SSH into EC2, pull & run Docker image.                   |
| `pages`          | Deploys the frontend via **GitLab Pages**.               |

✅ Pipelines trigger **on push/merge to `main`.**

---

##  How to Deploy

1️⃣ **Run Terraform:**

```bash
cd infra
terraform init
terraform apply
```

👉 Copy the output (e.g., EC2 IP, SSH key, DB credentials) into **GitLab CI/CD variables**.

2️⃣ **Push to `main`:**

* The pipeline runs and deploys everything.

---

##  Accessing the App

* **Backend API:**
  Visit: `http://<Load-Balancer-DNS>:8000/api/goals`

* **Frontend Website:**
  Visit your **GitLab Pages URL** (visible under your repository’s **Pages settings**).

---

##  Security Notes

* SSH keys & database credentials are stored as **GitLab CI/CD variables** (protected & masked).
* The database and EC2 instances are deployed in **private subnets** for security.

---


---

##  Authors

* **Emad Sawan**
* **Tavgar**
* Course: HBO-ICT DevOps
* University: Saxion

