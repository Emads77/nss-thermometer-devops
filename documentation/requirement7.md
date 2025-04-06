
## 7. Create a Backend with High Availability

This section explains how we extended our Terraform configuration to deploy a highly available backend and a redundant database, while ensuring the frontend connects to the new infrastructure.

### High Availability Backend

- **Auto Scaling Group (ASG):**
  - **Configuration:**
    - Deployed across two private subnets (in different Availability Zones: us-east-1a and us-east-1b).
    - Configured with a desired capacity of 2 (minimum of 2, maximum of 3).
    - Uses a launch template that includes a user data script to install Docker and pull the latest backend image from our GitLab registry.
  - **Purpose:**
    - Ensures the backend remains operational even if one Availability Zone fails.
    - Supports rolling updates and automatically replaces unhealthy instances.

- **Application Load Balancer (ALB):**
  - **Configuration:**
    - Deployed in public subnets with an attached security group allowing inbound HTTP traffic on port 80.
    - Listens on port 80 and forwards traffic to a target group containing our backend instances (listening on port 8000).
    - Uses health checks (e.g., an HTTP request expecting a 200 response on the "/" path) to ensure only healthy instances receive traffic.
  - **Purpose:**
    - Distributes incoming requests among backend instances using a round-robin algorithm.
    - Enhances fault tolerance by automatically rerouting traffic from unhealthy instances.

- **Network Isolation:**
  - **Configuration:**
    - Backend instances are placed in private subnets, making them inaccessible directly from the internet.
    - Outbound traffic from these subnets is routed through a NAT Gateway (located in a public subnet).
  - **Purpose:**
    - Enhances security by ensuring that only the ALB is exposed to external traffic, while backend servers remain protected.

### Redundant Database

- **Multi-AZ RDS PostgreSQL Instance:**
  - **Configuration:**
    - Deployed with Multi-AZ enabled, automatically replicating data to a standby instance in a separate Availability Zone.
    - Located within a dedicated DB subnet group spanning two private subnets.
  - **Purpose:**
    - Provides high availability and failover capabilities.
    - Ensures that the database remains accessible even if one Availability Zone encounters an issue.
- **Database Security:**
  - Configured to allow PostgreSQL (port 5432) connections only from the backend’s security group, limiting access to authorized application servers.

### Frontend Integration and Validation

- **Frontend Reconfiguration:**
  - **Adjustment:**  
    The frontend was reconfigured to use the ALB’s DNS name as its API endpoint. This small but crucial adjustment ensures that the frontend always connects to the current backend infrastructure.
- **Validation:**
  - The successful deployment is validated by checking if the frontend correctly displays the goals, confirming that it can communicate with the highly available backend and redundant database.

---

### Conclusion

By leveraging an Auto Scaling Group, an Application Load Balancer, and a Multi-AZ RDS PostgreSQL instance, our Terraform configuration provides a robust, highly available backend. Additionally, by adjusting the frontend to consume the ALB’s endpoint, we ensure seamless connectivity between the frontend and the backend. This approach meets the assignment requirements while maintaining security, scalability, and high availability.

---