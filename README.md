# 🏦 NexaBank — Production-Grade 3-Tier Banking App on AWS

![AWS](https://img.shields.io/badge/AWS-EKS%20%7C%20RDS%20%7C%20VPC-orange)
![Terraform](https://img.shields.io/badge/IaC-Terraform-purple)
![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-blue)
![Docker](https://img.shields.io/badge/Container-Docker-blue)

## 🏗️ Architecture

A highly available, scalable and fault tolerant 3-tier banking application deployed on AWS.

┌─────────────────────────────────────────────────┐
                     │                   AWS Cloud                      │
                     │                                                   │
Internet             │  ┌─────────────────────────────────────────────┐ │
   │                 │  │                  VPC                         │ │
   ▼                 │  │                                               │ │
┌──────────┐            │  │  ┌─────────────┐      ┌─────────────────┐   │ │
│   Users  │            │  │  │Public Subnet│      │ Private Subnet  │   │ │
└────┬─────┘            │  │  │             │      │                 │   │ │
│                  │  │  │ ┌─────────┐ │      │ ┌───────────┐  │   │ │
▼                  │  │  │ │   ALB   │ │─────▶│ │  EKS      │  │   │ │
┌──────────┐            │  │  │ └─────────┘ │      │ │  Cluster  │  │   │ │
│  Route53 │            │  │  │             │      │ │           │  │   │ │
└────┬─────┘            │  │  │ ┌─────────┐ │      │ │ Frontend  │  │   │ │
│                  │  │  │ │Bastion  │ │      │ │  Pods(2)  │  │   │ │
▼                  │  │  │ │  Host   │ │      │ │           │  │   │ │
┌──────────┐            │  │  │ └─────────┘ │      │ │ Backend   │  │   │ │
│   ALB    │            │  │  │             │      │ │  Pods(3)  │  │   │ │
└────┬─────┘            │  │  │ ┌─────────┐ │      │ └─────┬─────┘  │   │ │
│                  │  │  │ │   NAT   │ │      │       │        │   │ │
│                  │  │  │ │Gateway  │ │      │       ▼        │   │ │
│                  │  │  │ └─────────┘ │      │ ┌───────────┐  │   │ │
│                  │  │  └─────────────┘      │ │    RDS    │  │   │ │
│                  │  │                        │ │PostgreSQL │  │   │ │
│                  │  │                        │ │ Multi-AZ  │  │   │ │
│                  │  │                        │ └───────────┘  │   │ │
│                  │  │                        └─────────────────┘   │ │
│                  │  │                                               │ │
│                  │  │  ┌─────────────────────────────────────────┐ │ │
│                  │  │  │           Monitoring                     │ │ │
│                  │  │  │  ┌────────────┐    ┌───────────────┐    │ │ │
│                  │  │  │  │ Prometheus │───▶│    Grafana    │    │ │ │
│                  │  │  │  └────────────┘    └───────────────┘    │ │ │
│                  │  │  └─────────────────────────────────────────┘ │ │
│                  │  └─────────────────────────────────────────────┘ │
│                  └─────────────────────────────────────────────────┘
│
│         ┌─────────────────────────────────────────────┐
│         │              S3 + DynamoDB                   │
└────────▶│         (Terraform Remote State)             │
└─────────────────────────────────────────────┘




## Internet → ALB → EKS (Frontend + Backend) → RDS PostgreSQL

## 🚀 Tech Stack

| Layer | Technology |
|---|---|
| Infrastructure | Terraform |
| Cloud | AWS (EKS, RDS, VPC, S3, EC2) |
| Orchestration | Kubernetes |
| Containerization | Docker |
| Frontend | HTML/CSS/JS + Nginx |
| Backend | Python Flask |
| Database | PostgreSQL (Multi-AZ) |
| Monitoring | Prometheus + Grafana |

## ✨ Features
- ✅ User Registration & Login
- ✅ Account Balance Dashboard
- ✅ Transaction History
- ✅ Fund Transfers
- ✅ Real-time Monitoring

## 🔒 Security
- All resources in private subnets
- Security Groups with least-privilege
- RDS not publicly accessible
- Bastion Host for admin access

## 📊 Monitoring
- Prometheus metrics collection
- Grafana dashboards
- Node & Pod level monitoring

## 👤 Author
**Baskaran** — DevOps Engineer