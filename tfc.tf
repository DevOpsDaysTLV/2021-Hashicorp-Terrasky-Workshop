resource "tfe_workspace" "tfc_config" {
  name                = "TerraformCloudSeed"
  organization        = var.tfe_organization_name
  tag_names           = ["devopsdaystlv2021"]
  execution_mode      = "remote"
  auto_apply          = true
  global_remote_state = true
  vcs_repo {
    identifier     = "${var.github_username}/2021-Hashicorp-Terrasky-Workshop"
    oauth_token_id = var.oauth_token_id
  }
  working_directory = "00-tfc"
  queue_all_runs    = false
}

resource "tfe_variable" "organization_name" {
  key          = "tfe_organization_name"
  value        = "Provide me"
  category     = "terraform"
  workspace_id = tfe_workspace.tfc_config.id
  description  = "Org Name"
}

resource "tfe_variable" "oauth_token_id" {
  key          = "oauth_token_id"
  value        = "Provide me and make me sensitive"
  category     = "terraform"
  workspace_id = tfe_workspace.tfc_config.id
  description  = "OAuth Token"
}

resource "tfe_variable" "github_username" {
  key          = "github_username"
  value        = "Provide me"
  category     = "terraform"
  workspace_id = tfe_workspace.tfc_config.id
  description  = "GitHub Username"
}

resource "tfe_variable" "tfe_token" {
  key          = "TFE_TOKEN"
  value        = "Provide me and make me sensitive"
  category     = "env"
  workspace_id = tfe_workspace.tfc_config.id
  description  = "TFC Token"
}
