# Deployment Guide

## Prerequisites

1. AWS Account with appropriate permissions
2. AWS CLI configured
3. Terraform installed
4. Docker installed
5. GitHub account with repository access

## Steps to Deploy

### 1. Initialize Infrastructure (Dev)

```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

### 2. Build and Push Docker Image

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr get-login-password | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

docker build -t $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-portfolio-dev:1.0.0 app/
docker push $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-portfolio-dev:1.0.0
```

### 3. Update ECS Service

```bash
aws ecs update-service \
  --cluster devops-portfolio-dev-cluster \
  --service devops-portfolio-dev-service \
  --force-new-deployment
```

### 4. Verify Deployment

```bash
ALB_DNS=$(terraform output -raw alb_dns_name -var-file=environments/dev.tfvars)
curl http://$ALB_DNS/health
curl http://$ALB_DNS/api/info
```

## Troubleshooting

### ECS Tasks not starting
```bash
# Check task logs
aws logs tail /ecs/devops-portfolio-dev --follow

# Check service events
aws ecs describe-services \
  --cluster devops-portfolio-dev-cluster \
  --services devops-portfolio-dev-service
```

### Database connection issues
```bash
# Check security group
aws ec2 describe-security-groups --group-ids sg-xxxxx

# Test connectivity from ECS task (via Systems Manager)
aws ecs execute-command \
  --cluster devops-portfolio-dev-cluster \
  --task <task-id> \
  --container devops-portfolio \
  --interactive \
  --command "/bin/sh"
```

## Cleanup

To avoid charges, destroy infrastructure:

```bash
terraform destroy -var-file=environments/dev.tfvars
```