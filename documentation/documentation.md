
# Exam Assignment DevOps — NSS Thermometer
*by Tavgar El Ahmed & Emad Sawan*

---

## Functional Requirements

### 1. Add Data to the Backend

**Solution Description:**  
For this requirement, we implemented a Bash script (`add_data.sh`) that reads a data file (`data.md`) and performs POST requests to seed the Laravel backend with goals.
- **Reference:** [Requirement 1: Adding Data to the Backend](requirement1.md)

---

### 2. Containerization of the Applications

**Overview:**  
The goal was to containerize the entire NSS Thermometer application, which consists of:
- **Backend:** A Laravel application.
- **Frontend:** A static web application served by Nginx.
- **Database:** A PostgreSQL instance.
- **Seeder Script:** A script to seed the backend with initial data.

**Approach:**  
Containerization is achieved using Docker and orchestrated with Docker Compose. This setup ensures portability, scalability, and ease of management, while allowing flexible configuration via environment variables.

**Solution Description:**
- **Reference:** [Requirement 2: Containerization of the applications](requirement2.md)

---

### 3. Continuous Integration (CI)

**Overview:**  
The CI pipeline is structured into two main phases:
- **Backend Testing:** Automated testing of the backend application.
- **Frontend Building and Artifact Storage:** Building the frontend application and storing the build artifacts for deployment.

**Goal:**  
To streamline and automate testing, building, and deployment processes.

**Solution Description:**
- **Reference:** [Requirement 3: Continuous Integration](requirement3.md)

---

### 4. Initial AWS Infrastructure with Terraform

**Overview:**  
We set up the initial AWS infrastructure using Terraform. This infrastructure provides the foundation for deploying our application to the cloud.

**Solution Description:**
- **Reference:** [Requirement 4: Initial AWS Infrastructure with Terraform](requirement4.md)

---

### 5. Continuous Deployment (CD)

**Overview:**  
Continuous Deployment is automated via our GitLab CI/CD pipeline. On every push to the main branch, the pipeline:
- Builds the necessary Docker images.
- Uploads images to the GitLab container registry.
- Connects via SSH to deploy and run the images on the EC2 instance.
- Deploys the frontend as a static website.

**Solution Description:**
- **Reference:** [Requirement 5: Continuous Deployment (CD)](requirement5.md)

---

### 7. High Availability Backend

**Overview:**  
We extended our Terraform configuration to deploy a highly available backend and a redundant database. This ensures that the backend remains accessible and resilient, even in case of failures.

**Solution Description:**
- **Reference:** [Requirement 7: backend with high availability ](requirement7.md)

## References

*(Include your references here)*

---

## Additional Notes

*(Include any extra notes or comments here)*

---