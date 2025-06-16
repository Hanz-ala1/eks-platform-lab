variable "aws_region" {
    description = "AWS Region"
    type        = string
    default     = "eu-west-2"  
}

variable "aws_profile" {
    description = "AWS CLI profile name"
    type        = string
    default     = "default"
}

variable "cluster_name" {
  description   = "EKS cluster name"
  type          = string
}

variable "vpc_id" {
    description = "VPC ID to use for eks"
    type        = string
  
}

variable "subnet_ids" {
  description = "Subnet IDS for the eks cluster"
  type        = list(string)
}