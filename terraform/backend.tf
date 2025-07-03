terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-lab-deployment"
    key    = "envs/dev/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    use_lockfile = true
  }
}