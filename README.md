
1. Create Terraform Cloud account
2. Create organization
3. Add VCS provider (github)
4. `terraform login`

# required envs for initial TFC magic (maybe provided interactively)
TF_VAR_tfc_organization_name
TF_VAR_oauth_token_id
TF_VAR_github_username
TF_VAR_tfc_token 

5. root: terraform init
6. root: terraform apply
7. TerraformCloudSeed: add TFE_TOKEN variable and run again
8. TerraformCloudSeed: run manual apply from web ui
9. create HCP account including organization
10. create principal and generate token
