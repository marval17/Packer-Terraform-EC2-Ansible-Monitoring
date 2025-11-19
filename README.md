PredictionML

End-to-end cloud-native machine learning platform that ingests NBA data, trains predictive models, deploys microservices on Kubernetes, and exposes real-time predictions through an API and frontend — all powered by Terraform, EKS, ArgoCD, Docker, Prometheus, and Grafana.

Platform Delivery Pipeline

End-to-end DevOps + MLOps workflow that automates data ingestion, model training, infrastructure provisioning, microservice deployment, and monitoring.

┌───────────────┐
│     DATA      │ → NBA stats ingestion + ETL jobs
└──────┬────────┘
       │
┌──────▼──────┐
│   ML JOBS   │ → Nightly model training + artifact output
└──────┬──────┘
       │
┌──────▼─────────┐
│   TERRAFORM    │ → AWS VPC, EKS, RDS, ECR, IAM
└──────┬─────────┘
       │
┌──────▼──────┐
│ KUBERNETES  │ → prediction-api, frontend, ETL, CronJobs
└──────┬──────┘
       │
┌──────▼─────────────┐
│  ARGOCD (GitOps)    │ → Continuous deployment
└──────┬──────────────┘
       │
┌──────▼──────────────┐
│ PROMETHEUS/GRAFANA  │ → Metrics, dashboards, alerts
└──────────────────────┘

Repository Layout
Path	Description
terraform/	Terraform configuration that provisions the AWS VPC, private/public subnets, NAT gateway, EKS cluster, RDS PostgreSQL instance, ECR repositories, and IAM roles.
services/prediction-api/	Python/Node inference service that loads the trained model and exposes an API for prediction requests.
services/data-service/	ETL/ingestion microservice that fetches NBA data and loads it into the RDS database.
services/ml-jobs/	Kubernetes CronJobs for nightly training + model artifact generation.
services/frontend/	Frontend application that displays predictions and game insights.
kubernetes/	Kubernetes manifests deployed via ArgoCD (Ingress, Deployments, CronJobs, ConfigMaps, Services, etc.).
.github/workflows/	GitHub Actions workflows that build/push Docker images to ECR and trigger GitOps sync.
Workflow
1. Data ingestion

data-service connects to NBA APIs, collects game/player stats, and stores processed data in RDS.

2. Model training

ml-jobs CronJob trains a fresh model nightly and uploads the serialized artifact to S3 or internal storage.

3. Infrastructure provisioning

Terraform provisions the full AWS environment:

VPC + subnets

EKS cluster + node groups

RDS Postgres

ECR repositories

IAM roles, OIDC, SGs

Outputs include:

Kubernetes cluster config

Database endpoint

ECR URLs

4. Application deployment

ArgoCD monitors the GitOps manifests in kubernetes/ and continuously deploys:

prediction-api

frontend

ETL pipelines

ML training CronJobs

Ingress rules

5. Monitoring

Prometheus scrapes:

API latency

CronJob performance

Pod health

DB connection metrics

Cluster utilization

Grafana provides dashboards for:

Model inference performance

Training job health

EKS node/pod metrics

API throughput

Getting Started
1. Deploy Infrastructure
cd terraform
terraform init
terraform apply -var-file="env.tfvars"

2. Configure kubectl
aws eks update-kubeconfig --region us-east-1 --name predictionml-eks
kubectl get nodes

3. Deploy Microservices

ArgoCD automatically applies manifests from the kubernetes/ directory.

Optional manual apply:

kubectl apply -f kubernetes/

4. Run Data Ingestion / Training Jobs

CronJobs run automatically, but you can manually trigger:

kubectl create job --from=cronjob/ml-train ml-train-manual

5. Access Grafana & Prometheus

Port forward via kubectl:

kubectl port-forward svc/grafana 3000:3000 -n monitoring
kubectl port-forward svc/prometheus-server 9090:9090 -n monitoring

Roadmap

NBA live-streaming stats ingestion

Multiple model versions (model registry)

Canary deployments for new model releases

CI/CD automation from GitHub → ECR → ArgoCD

Feature store for ML inputs

Model performance dashboards in Grafana

Real-time prediction endpoint rate limiting + caching
