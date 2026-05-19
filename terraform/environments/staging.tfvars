aws_region  = "us-east-2"
environment = "staging"
vpc_cidr    = "10.1.0.0/16"

app_name          = "devops-portfolio"
container_port    = 8000
container_image   = "661000947388.dkr.ecr.us-east-2.amazonaws.com/devops-portfolio-staging:latest"

ecs_task_cpu     = 256
ecs_task_memory  = 512
ecs_desired_count = 2
ecs_min_capacity  = 2
ecs_max_capacity  = 4

db_instance_class   = "db.t3.small"
db_allocated_storage = 50
enable_rds_backup    = true
backup_retention_days = 7