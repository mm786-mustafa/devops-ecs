aws_region  = "us-east-2"
environment = "dev"
vpc_cidr    = "10.0.0.0/16"

app_name          = "devops-portfolio"
container_port    = 8000
container_image   = "661000947388.dkr.ecr.us-east-2.amazonaws.com/devops-portfolio-dev:latest"

ecs_task_cpu     = 256
ecs_task_memory  = 512
ecs_desired_count = 1
ecs_min_capacity  = 1
ecs_max_capacity  = 2

db_instance_class   = "db.t3.micro"
db_allocated_storage = 20
enable_rds_backup    = false
backup_retention_days = 1