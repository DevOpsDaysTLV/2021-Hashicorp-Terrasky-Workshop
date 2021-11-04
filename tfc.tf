resource "tfe_workspace" "tfc_config" {
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
  working_directory = "00-tfc"
}
