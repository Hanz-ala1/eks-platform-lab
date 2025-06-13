module "eks" {
    source          = "terraform-aws-modules/eks/aws"
    version         = "20.8.4"

    cluster_name    = var.cluster_name
    cluster_version = "1.31"
    subnet_ids      = var.subnet_ids
    vpc_id          = var.vpc_id


manage_aws_auth_configmap = true

eks_managed_node_groups = {
  default_node_group = {
    desired_size = 2
    max_size     = 3
    mix_size     = 1

    instace_types = ["t3.medium"]
    }
  }
  tags {
    Environment = "dev"
    Terraform   = "true"
  }
} 