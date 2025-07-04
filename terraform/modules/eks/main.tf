module "eks" {
    source          = "terraform-aws-modules/eks/aws"
    version         = "20.8.4"

    cluster_name    = var.cluster_name
    cluster_version = var.cluster_version
    subnet_ids      = var.subnet_ids
    vpc_id          = var.vpc_id

    enable_cluster_creator_admin_permissions = true

    eks_managed_node_groups = {
        default_node_group = {
            desired_size = 2
            max_size     = 3
            min_size     = 1
            instance_types = ["t3.small"]
    }
  }
    tags = var.tags
}
