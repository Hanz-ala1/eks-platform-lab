terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-lab-deployment"
    key    = "envs/dev/terraform.tfstate"
    region = "eu-west-2"
  }
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
      }
    }

    required_version = ">=1.3.0"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


