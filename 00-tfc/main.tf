resource "tfe_workspace" "vpc" {
  name                = "VPC"
  organization        = var.tfe_organization_name
  tag_names           = ["devopsdaystlv2021"]
  execution_mode      = "remote"
  auto_apply          = true
  global_remote_state = true
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory = "01-vpc"
}

resource "tfe_workspace" "hvn" {
  name         = "HVN"
  organization = var.tfe_organization_name
  tag_names    = ["devopsdaystlv2021"]
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory   = "02-hvn"
  execution_mode      = "remote"
  auto_apply          = true
  global_remote_state = true
}

resource "tfe_variable" "organization_name_for_hvn" {
  key          = "tfe_organization_name"
  value        = var.tfe_organization_name
  category     = "terraform"
  workspace_id = tfe_workspace.hvn.id
  description  = "Org Name"
}

resource "tfe_workspace" "eks" {
  name         = "EKS"
  organization = var.tfe_organization_name
  tag_names    = ["devopsdaystlv2021"]
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory = "03-eks"
}

resource "tfe_variable" "organization_name_for_eks" {
  key          = "tfe_organization_name"
  value        = var.tfe_organization_name
  category     = "terraform"
  workspace_id = tfe_workspace.eks.id
  description  = "Org Name"
  depends_on = [
    tfe_workspace.eks
  ]
}
