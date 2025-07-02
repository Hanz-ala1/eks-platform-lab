# eks-platform-lab
Platform Engineering Lab – EKS Deployment

Terraform AWS EKS Cluster
This repository contains the Terraform code to provision a foundational AWS Elastic Kubernetes Service (EKS) cluster. It is designed as the underlying infrastructure layer, ready for application deployments managed by a GitOps controller like Argo CD or Flux.

This project serves as a practical example of Infrastructure as Code (IaC) for building a scalable and robust Kubernetes platform on AWS.

System Architecture
The following diagram illustrates the architecture of the AWS resources provisioned by this Terraform code. It includes a multi-AZ VPC, public and private subnets, and an EKS cluster with a managed node group. The Terraform state is securely stored in an S3 bucket.

Core Components
VPC: A custom Virtual Private Cloud (VPC) is created with a /16 CIDR block, providing a logically isolated section of the AWS Cloud. It is configured with both public and private subnets across three Availability Zones for high availability.

EKS Cluster: A managed Kubernetes control plane is provisioned using the official terraform-aws-modules/eks/aws module.

Managed Node Group: A group of EC2 instances (t3.small by default) that are registered as worker nodes for the EKS cluster. This group is configured to autoscale based on demand.

Terraform S3 Backend: The Terraform state is stored remotely in an AWS S3 bucket, which is crucial for team collaboration and state locking.

Prerequisites
Before you begin, ensure you have the following installed and configured:

Terraform (version >= 1.3.0)

AWS CLI

Configured AWS Credentials with permissions to create the resources defined in this project. You can configure this by running aws configure.

Costs:

Total Estimated Hourly Cost
Resource	Count	Unit Cost (USD)	Total (USD/hr)
EKS Control Plane	1	$0.10	$0.10
EC2 t3.small instances	2	$0.0208	$0.0416
EBS storage	2x 8GB	~$0.001	$0.002
S3 state (free tier)	-	$0.00	$0.00
Estimated Total/hr	-	-	~$0.1436

Configuration & Deployment
Follow these steps to deploy the EKS cluster.

1. Clone the Repository
git clone <your-repository-url>
cd <repository-directory>

2. Configure the S3 Backend
The main.tf file is configured to use an S3 backend. You must create this S3 bucket in your AWS account before running Terraform.

-- Create your own bucket name and replace this

Bucket Name: terraform-state-bucket-lab-deployment
Region: eu-west-2

Update the backend "s3" block in main.tf if you use a different bucket name or region.

3. Customize Input Variables
The primary variable to configure is the cluster_name. Create a terraform.tfvars file in the root of the directory:

# terraform.tfvars
cluster_name = "choose the name of your cluster"

Other variables like aws_region and aws_profile can be found in variables.tf and can be overridden in your terraform.tfvars file if needed.

4. Initialize Terraform
This command initializes the working directory, downloads the required providers, and configures the backend.

terraform init

5. Plan the Deployment
This command creates an execution plan, showing you what resources Terraform will create, modify, or destroy.

terraform plan  -var-file=terraform.tfvars

6. Apply the Configuration
This command applies the changes required to reach the desired state of the configuration.

terraform apply -var-file=terraform.tfvars

Enter yes when prompted to confirm the deployment. The process will take several minutes to complete.

Connecting to the Cluster
Once the terraform apply command is complete, you will need to configure kubectl to connect to your new EKS cluster.

Update Kubeconfig: Use the AWS CLI to update your local kubeconfig file.

aws eks update-kubeconfig --region $(terraform output -raw aws_region) --name $(terraform output -raw cluster_name)

or 

aws eks update-kubeconfig --region name of region --name name of cluster

Update the endpoint so you connect

aws eks update-cluster-config --name CLUSTER_NAME --region REGION --resources-vpc-config endpointPublicAccess=true

Verify Connection: Test your connection to the cluster.

kubectl get nodes

You should see the nodes from your managed node group with a Ready status.

Project Outputs
This project provides several useful outputs, defined in outputs.tf:

cluster_name: The name of the EKS cluster.

cluster_endpoint: The endpoint for your EKS cluster's API server.

cluster_arn: The Amazon Resource Name (ARN) of the cluster.

vpc_id: The ID of the VPC created for the cluster.

private_subnets: A list of the private subnet IDs.

You can view these outputs at any time by running:

terraform output

Next Steps: GitOps Integration
This Terraform project intentionally focuses only on provisioning the core infrastructure. The next logical step is to set up a GitOps workflow to manage applications on the cluster.

This EKS cluster is now ready for a GitOps controller like Argo CD or Flux to be installed. The GitOps controller would then monitor a separate Git repository (your application/manifests repository) and automatically deploy and manage applications on this cluster.

Destroying the Infrastructure
To avoid ongoing charges, you can destroy all the resources created by this project when they are no longer needed.

Warning: This is a destructive operation and cannot be undone.

terraform destroy -var-file=terraform.tfvars

Enter yes when prompted to confirm.
