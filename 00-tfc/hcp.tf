resource "tfe_workspace" "hcp" {
  name         = "HCP"
  organization = var.tfe_organization_name
  tag_names    = ["devopsdaystlv2021"]
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory   = "02-hcp"
  execution_mode      = "remote"
  auto_apply          = true
  global_remote_state = true
  queue_all_runs      = false
}

resource "tfe_variable" "organization_name_for_hcp" {
  key          = "tfe_organization_name"
  value        = var.tfe_organization_name
  category     = "terraform"
  workspace_id = tfe_workspace.hvn.id
  description  = "Org Name"
}

resource "tfe_variable" "aws_access_key_id_for_hcp" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = "Provide me and make me sensitive"
  category     = "env"
  workspace_id = tfe_workspace.hcp.id
}

resource "tfe_variable" "aws_secret_access_key_for_hcp" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = "Provide me and make me sensitive"
  category     = "env"
  workspace_id = tfe_workspace.hcp.id
}

resource "tfe_variable" "hcp_client_id" {
  key          = "HCP_CLIENT_ID"
  value        = "Provide me and make me sensitive"
  category     = "env"
  workspace_id = tfe_workspace.hcp.id
}

resource "tfe_variable" "hcp_client_secret" {
  key          = "HCP_CLIENT_SECRET"
  value        = "Provide me and make me sensitive"
  category     = "env"
  workspace_id = tfe_workspace.hcp.id
}

resource "tfe_run_trigger" "vpc_hcp" {
  workspace_id  = tfe_workspace.hcp.id
  sourceable_id = tfe_workspace.vpc.id
}
