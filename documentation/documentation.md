# Exam Assignment DevOps — NSS Thermometer
by Tavgar El Ahmed & Emad Sawan

---

## Functional Requirements

### 1. Add Data to the Backend

#### Solution Description

- [Requirement 1: Adding Data to the Backend](requirement1.md)


---

### 2. Containerization of the Applications

## Overview

For this requirement, the goal was to containerize the entire NSS Thermometer application, which includes:
- **Backend:** A Laravel application.
- **Frontend:** A static web application served by Nginx.
- **Database:** A PostgreSQL instance.
- **Seeder Script:** A script to seed the backend with initial data.

Containerization is achieved using **Docker** and orchestrated with **Docker Compose**. This approach ensures that the application is portable, scalable, and easy to manage, while also allowing us to leverage environment variables for flexible configuration.

#### Solution Description


- [Requirement 2: Containerization of the applications](requirement2.md)


---

### 3. Continuous Integration (CI)

The Continuous Integration (CI) pipeline is structured into two 
main phases: Backend Testing, 
and Frontend Building and Artifact Storage. 
The goal of these phases is to streamline and automate the testing, 
building, and deployment processes efficiently.

- [Requirement 3: Continuous Integration](requirement3.md)

---

### 4. Initial AWS Infrastructure with Terraform

- [Requirement 4: Initial AWS Infrastructure with Terraform](requirement4.md)

---

### 5. Continuous Deployment (CD)

#### Deployment Automation

#### Gitlab CI/CD Integration

#### Static Website Hosting

---

### 6. High Availability Backend

#### HA Configuration & Terraform

#### Database Redundancy

#### Network & Security

---

## References


---

## Additional Notes

