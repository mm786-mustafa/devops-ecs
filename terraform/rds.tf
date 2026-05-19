# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "${var.app_name}-${var.environment}-db-subnet-group"
  }
}

# Random password for RDS
resource "random_password" "rds_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}:,.?"
}

# Store RDS password in Secrets Manager
resource "aws_secretsmanager_secret" "rds_password" {
  name_prefix = "${var.app_name}-${var.environment}-rds-password"

  tags = {
    Name = "${var.app_name}-${var.environment}-rds-secret"
  }
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_password.rds_password.result
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier            = "${var.app_name}-${var.environment}-db"
  engine               = "postgres"
  engine_version       = var.db_engine_version
  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  storage_encrypted    = true
  multi_az             = var.environment == "prod" ? true : false

  db_name  = "myapp"
  username = "postgres"
  password = random_password.rds_password.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_days
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  copy_tags_to_snapshot  = true

  deletion_protection = var.environment == "prod" ? true : false
  skip_final_snapshot = var.environment == "prod" ? false : true

  tags = {
    Name = "${var.app_name}-${var.environment}-db"
  }
}