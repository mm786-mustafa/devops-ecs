# Architecture Documentation

## Overview
This project demonstrates a production-ready multi-environment deployment pipeline using:
- **Infrastructure:** AWS ECS Fargate with Terraform
- **CI/CD:** GitHub Actions
- **Monitoring:** CloudWatch + Alarms
- **Networking:** VPC with public/private subnets, NAT gateways, ALB

## Environment Tiers

### Development
- **Purpose:** Rapid iteration, testing new features
- **Compute:** 1-2 ECS tasks (Fargate)
- **Database:** Shared single-AZ RDS (db.t3.micro)
- **Backup:** Minimal (1 day retention)
- **Cost:** ~$50/month

### Staging
- **Purpose:** Pre-production testing, load testing
- **Compute:** 2-4 ECS tasks (70% on-demand, 30% Spot)
- **Database:** Single-AZ RDS (db.t3.small)
- **Backup:** 7-day retention
- **Cost:** ~$80/month

### Production
- **Purpose:** Live traffic
- **Compute:** 3-10 ECS tasks (auto-scaling)
- **Database:** Multi-AZ RDS (db.t3.medium) for HA
- **Backup:** 30-day retention, daily snapshots
- **Monitoring:** Enhanced CloudWatch, alarms
- **Cost:** ~$150-300/month (depending on traffic)

## Network Architecture

┌─────────────────────────────────────────────────────────┐
│                        VPC (10.0.0.0/16)                │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │              Public Subnets                      │  │
│  │  (AZ-1: 10.0.0.0/20)  (AZ-2: 10.0.1.0/20)      │  │
│  │  ┌──────────────────┐  ┌──────────────────┐    │  │
│  │  │   NAT Gateway 1  │  │   NAT Gateway 2  │    │  │
│  │  └──────────────────┘  └──────────────────┘    │  │
│  │  ┌──────────────────┐  ┌──────────────────┐    │  │
│  │  │  ALB             │                       │    │  │
│  │  │  Port 80/443     │                       │    │  │
│  │  └──────────────────┘                       │    │  │
│  └──────────────────────────────────────────────────┘  │
│                        │                                │
│  ┌──────────────────────────────────────────────────┐  │
│  │              Private Subnets                     │  │
│  │  (AZ-1: 10.0.2.0/20)  (AZ-2: 10.0.3.0/20)     │  │
│  │  ┌──────────────────┐  ┌──────────────────┐   │  │
│  │  │ ECS Tasks        │  │ ECS Tasks        │   │  │
│  │  │ (Port 8000)      │  │ (Port 8000)      │   │  │
│  │  └──────────────────┘  └──────────────────┘   │  │
│  │  ┌──────────────────┐  ┌──────────────────┐   │  │
│  │  │ RDS Primary      │  │ RDS Standby      │   │  │
│  │  │ (Port 5432)      │  │ (Multi-AZ)       │   │  │
│  │  └──────────────────┘  └──────────────────┘   │  │
│  └──────────────────────────────────────────────────┘  │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │          Internet Gateway                        │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘

## Deployment Flow

Developer
│
└─→ git push
│
└─→ GitHub (PR review)
│
└─→ GitHub Actions
├─→ Run tests
├─→ Build Docker image
├─→ Push to ECR
└─→ Deploy to ECS
│
├─→ Dev (auto)
├─→ Staging (manual approval optional)
└─→ Prod (manual approval required)

## Cost Optimization

- **Fargate Spot Instances:** 70% on-demand, 30% Spot (saves ~30%)
- **Reserved Instances:** Available for prod RDS
- **Rightsizing:** Dev uses micro instances, prod scales up
- **Auto-scaling:** Scales down during off-peak hours

## Security Features

- **VPC:** Private subnets for application and database
- **Secrets Manager:** Database passwords stored securely
- **IAM Roles:** Least privilege access for ECS tasks
- **Security Groups:** Restrictive ingress/egress rules
- **SSL/TLS:** Ready for ACM certificates (Phase 2)

## Monitoring & Alarms

- **CloudWatch:** Container logs, metrics, dashboards
- **Alarms:** CPU, memory, database metrics
- **Health Checks:** ECS task health checks, ALB target health