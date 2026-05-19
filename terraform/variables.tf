variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "devops-ecs"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "container_port" {
  description = "Port exposed by container"
  type        = number
  default     = 8000
}

variable "container_image" {
  description = "Docker image URI"
  type        = string
}

variable "ecs_task_cpu" {
  description = "Task CPU units (256=0.25 vCPU, 1024=1 vCPU)"
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Task memory in MB"
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "ecs_min_capacity" {
  description = "Minimum task capacity for auto-scaling"
  type        = number
  default     = 1
}

variable "ecs_max_capacity" {
  description = "Maximum task capacity for auto-scaling"
  type        = number
  default     = 3
}

variable "db_engine_version" {
  description = "RDS PostgreSQL version"
  type        = string
  default     = "16.14"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 20
}

variable "enable_rds_backup" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "backup_retention_days" {
  description = "Days to retain backups"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Additional tags to apply"
  type        = map(string)
  default     = {}
}