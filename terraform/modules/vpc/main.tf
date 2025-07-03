module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

name = var.name
cidr = var.cidr

azs                 = var.azs
public_subnets      = var.public_subnets
private_subnets     = var.private_subnets

enable_dns_hostnames    = true
enable_dns_support      = true
map_public_ip_on_launch = true

tags = var.tags
}

