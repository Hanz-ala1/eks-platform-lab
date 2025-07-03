# 🚀 eks-platform-lab

**EKS Terraform Foundation: Rapid AWS Kubernetes Clusters**

This repository provisions a ready AWS EKS (Elastic Kubernetes Service) cluster using **Terraform**. It lays the groundwork for deploying cloud-native applications through GitOps tools such as **Argo CD** or **Flux**.

---

## 🧭 Overview

This project demonstrates **Infrastructure as Code (IaC)** to build a scalable and robust Kubernetes platform on AWS using:

- AWS EKS for Kubernetes orchestration
- Terraform for infrastructure automation
- Remote S3 state backend (with locking support)
- GitOps-ready foundation

---

## 🏗️ Architecture

<pre>
   ┌─────────────────────────────┐
   │         AWS Region          │
   │ ┌─────────────────────────┐ │
   │ │        VPC (10.0.0.0/16)│ │
   │ │ ┌──────────┐ ┌────────┐ │ │
   │ │ │ Public   │ │ Private│ │ │ 
   │ │ │ Subnets  │ │Subnets │ │ │ 
   │ │ │ • NAT GW │ │ • EKS  │ │ │ 
   │ │ │ • LB     │ │  Nodes │ │ │ 
   │ │ └──────────┘ └────────┘ │ │
   │ │     ┌────────────────┐  │ │
   │ │     │   EKS Cluster  │  │ │
   │ │     │ • API Server   │  │ │
   │ │     │ • Managed CP   │  │ │   # CP = Control Plane
   │ │     └────────────────┘  │ │
   │ │     ┌────────────────┐  │ │
   │ │     │ Managed Node   │  │ │
   │ │     │ Groups (EC2)   │  │ │
   │ │     │ • t3.small     │  │ │
   │ │     │ • Multi-AZ     │  │ │
   │ │     └────────────────┘  │ │
   │ └─────────────────────────┘ │
   └─────────────────────────────┘ 

</pre>

---


## 📦 Core Components
VPC: Custom /16 CIDR, public and private subnets across 3 AZs.

EKS Cluster: Provisioned using terraform-aws-modules/eks/aws.

Managed Node Group: Autoscaling EC2 worker nodes (t3.small).

Terraform Remote State: Stored in an S3 bucket with optional locking support via use_lockfile.

## Prerequisites
Terraform v1.10.0 or newer

AWS CLI version 2

AWS credentials configured via aws configure

An S3 bucket already created for the remote backend

Kubectl version 
Offically supported with the Eks Cluster	v1.30, v1.31, v1.32

<pre>
## 💰 Estimated Costs

| Resource               | Count | Cost (USD/hr) | Total    |
|------------------------|-------|---------------|----------|
| EKS Control Plane      | 1     | $0.10         | $0.10    |
| EC2 t3.small Instances | 2     | $0.0208       | $0.0416  |
| EBS (2x 8GB)           | 2     | $0.001        | $0.002   |
| S3 (State Backend)     | -     | Free Tier     | $0.00    |
| **Estimated Total/hr** |       |               | **$0.1436** |

⚠️ You are responsible for all AWS charges incurred by this infrastructure.
</pre>
--

## ⚙️ Configuration & Deployment
1️⃣ Clone the Repository

git clone https://github.com/your-org/eks-platform-lab.git
cd eks-platform-lab

2️⃣ Configure the S3 Backend
Edit the main.tf file with your S3 backend settings: This requires you creating an S3 bucket 

<pre>
hcl
terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-lab-deployment"
    key    = "envs/dev/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true
  }
</pre>
Make sure the bucket exists before running terraform init.

3️⃣ Customize Variables
Edit the terraform.tfvars file And give your cluster a name


cluster_name = "my-eks-cluster"
Other variables (e.g., aws_region, aws_profile) can be overridden here or in variables.tf.

4️⃣ Initialize Terraform

terraform init

5️⃣ Preview Changes

terraform plan -var-file=terraform.tfvars

6️⃣ Apply Configuration

terraform apply -var-file=terraform.tfvars

Confirm with yes when prompted.

🔗 Connect to Your EKS Cluster
Update Kubeconfig

aws eks update-kubeconfig \
  --region $(terraform output -raw aws_region) \
  --name   $(terraform output -raw cluster_name)

Optional: Enable Public Endpoint to connect to your cluster using kubectl

aws eks update-cluster-config \
  --name <CLUSTER_NAME> \
  --region <REGION> \
  --resources-vpc-config endpointPublicAccess=true

## **Verify Connection**

kubectl get nodes


📤 Terraform Outputs
Use terraform output to view:

cluster_name

cluster_endpoint

cluster_arn

vpc_id

private_subnets

🚀 Next Steps: GitOps Ready
Once the cluster is live, deploy Argo CD or Flux to enable GitOps workflows.

My GitOps Repo
+ [My GitOps Repo](https://github.com/Hanz-ala1/gitops)

### 🛡️ Production Readiness
This template is **optimized for speed and simplicity**, but enterprises should:  
- Replace admin IAM roles with **IRSA** ([guide](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html))  
- Enforce **Pod Security Admission** ([example](https://kubernetes.io/docs/concepts/security/pod-security-standards/))  
- Add **KMS encryption** for Terraform state (`kms_key_id` in S3 backend)  


🧨 Tear Down (Cleanup)
To destroy all resources and avoid ongoing charges:


terraform destroy -var-file=terraform.tfvars
⚠️ This is irreversible. Proceed with caution.

📚 Resources
Terraform AWS Provider
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

terraform-aws-eks module
https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

AWS EKS Documentation
https://docs.aws.amazon.com/eks/



🛡️ Disclaimer
This project is for educational and experimental purposes. You are solely responsible for any AWS usage charges incurred.

