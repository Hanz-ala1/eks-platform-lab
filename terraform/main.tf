terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-lab-deployment"
    key    = "envs/dev/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true
  }
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
      }
    }

    required_version = "~>1.10.0"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


