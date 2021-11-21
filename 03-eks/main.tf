data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = var.tfc_organization_name
    workspaces = {
      name = "VPC"
    }
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_security_group" "default" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_version                      = "1.21"
  cluster_name                         = "devopsdaytlv2021"
  vpc_id                               = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets                              = data.terraform_remote_state.vpc.outputs.public_subnets
  worker_additional_security_group_ids = [data.aws_security_group.default.id]
  worker_groups = [
    {
      instance_type = "m4.large"
      asg_max_size  = 5
    }
  ]
}
