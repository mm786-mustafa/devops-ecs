aws_region  = "us-east-2"
environment = "prod"
vpc_cidr    = "10.2.0.0/16"

app_name          = "devops-portfolio"
container_port    = 8000
container_image   = "661000947388.dkr.ecr.us-east-2.amazonaws.com/devops-portfolio-prod:latest"

ecs_task_cpu     = 512
ecs_task_memory  = 1024
ecs_desired_count = 3
ecs_min_capacity  = 3
ecs_max_capacity  = 10

db_instance_class   = "db.t3.medium"
db_allocated_storage = 100
enable_rds_backup    = true
backup_retention_days = 30