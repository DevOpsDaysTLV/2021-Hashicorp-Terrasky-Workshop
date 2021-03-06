resource "tfe_workspace" "eks" {
  name         = "EKS"
  organization = var.tfc_organization_name
  tag_names    = ["devopsdaystlv2021"]
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory   = "03-eks"
  execution_mode      = "remote"
  auto_apply          = true
  global_remote_state = true
  queue_all_runs      = false
}

// Need this for remote state sharing
resource "tfe_variable" "organization_name_for_eks" {
  key          = "tfc_organization_name"
  value        = var.tfc_organization_name
  category     = "terraform"
  workspace_id = tfe_workspace.eks.id
  description  = "Org Name"
  depends_on = [
    tfe_workspace.eks
  ]
}

resource "tfe_run_trigger" "vpc-eks" {
  workspace_id  = tfe_workspace.eks.id
  sourceable_id = tfe_workspace.vpc.id
}
