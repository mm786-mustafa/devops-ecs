# DevOps Portfolio: Multi-Environment ECS Deployment

A production-ready infrastructure as code project demonstrating DevOps best practices using AWS ECS, Terraform, and GitHub Actions.

## 🎯 Project Highlights

- **Multi-environment setup:** Dev, Staging, Production with environment parity
- **Infrastructure as Code:** Terraform modules for repeatable, version-controlled infrastructure
- **Automated CI/CD:** GitHub Actions for building, testing, and deploying
- **Auto-scaling:** Dynamic scaling based on CPU and memory metrics
- **Observability:** CloudWatch metrics, logs, and custom alarms
- **Security:** VPC isolation, IAM roles, Secrets Manager integration
- **Cost-optimized:** Fargate Spot instances (30% savings), auto-scaling policies

## 📊 Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed architecture documentation.

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/devops-portfolio-ecs.git
cd devops-portfolio-ecs
```

### 2. Set Up AWS Credentials
```bash
aws configure
```

### 3. Deploy Infrastructure
```bash
cd terraform
terraform init
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

### 4. Build and Push Application
```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
docker build -t $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-portfolio-dev:1.0.0 app/
docker push $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/devops-portfolio-dev:1.0.0
```

### 5. Deploy to ECS
```bash
aws ecs update-service \
  --cluster devops-portfolio-dev-cluster \
  --service devops-portfolio-dev-service \
  --force-new-deployment
```

### 6. Verify
```bash
ALB_DNS=$(terraform output -raw alb_dns_name -var-file=environments/dev.tfvars)
curl http://$ALB_DNS/health
```

## 📁 Project Structure

devops-ecs/
├── app/                          # Flask application
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
├── terraform/                    # Infrastructure as Code
│   ├── main.tf, variables.tf, outputs.tf
│   ├── vpc.tf, ecs.tf, rds.tf, alb.tf
│   ├── cloudwatch.tf
│   └── environments/             # Environment-specific vars
│       ├── dev.tfvars
│       ├── staging.tfvars
│       └── prod.tfvars
├── .github/workflows/            # GitHub Actions
│   └── deploy.yml
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DEPLOYMENT.md
│   └── COST-OPTIMIZATION.md
├── README.md
└── .gitignore

## 🔧 Technologies Used

- **Cloud:** AWS (ECS, ECR, RDS, VPC, CloudWatch, ALB)
- **IaC:** Terraform
- **CI/CD:** GitHub Actions
- **Container:** Docker
- **Application:** Python Flask
- **Database:** PostgreSQL

## 💰 Cost Estimates

| Environment | Monthly Cost |
|-------------|-------------|
| Development | ~$50 |
| Staging | ~$80 |
| Production | $150-300 |
| **Total** | **~$280-430** |

*Note: Costs may vary by region and data transfer*

## 📈 Key Metrics

- **Deployment Time:** < 10 minutes (including tests)
- **Scalability:** 1-10 tasks per environment
- **Availability:** 99.9% (multi-AZ in production)
- **Database Backups:** 7-30 days retention
- **Auto-scaling:** CPU and memory-based

## 🔐 Security Features

- VPC with private subnets for compute and database
- Security groups with least-privilege rules
- IAM roles for ECS task execution
- Secrets Manager for sensitive data
- CloudWatch monitoring and alarms
- Multi-AZ setup for production

## 📚 Learning Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GitHub Actions](https://docs.github.com/en/actions)

## 👤 Author

Muhammad Mustafa - DevOps Project

---
