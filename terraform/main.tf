module "vpc" {
  source = "./modules/vpc"

  name = "eks-lab-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "eks" {
    source          = "./modules/eks"

    cluster_name    = var.cluster_name
    cluster_version = "1.31"
    subnet_ids      = module.vpc.public_subnets
    vpc_id          = module.vpc.vpc_id

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}