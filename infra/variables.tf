variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Prefix for resource names"
  default     = "nss-thermometer-app"
}

variable "ami" {
  type = string
  description = "value"
  default = "ami-084568db4383264d4"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "public_key_path" {
  type        = string
  description = "Local path to the public key (for the AWS key pair)"
  default     = "~/.ssh/id_rsa.pub"
}

variable "my_ip_cidr" {
  type        = string
  description = "  IP address in CIDR notation for SSH access"
  default     = "0.0.0.0/0"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password for the PostgreSQL DB instance"
}