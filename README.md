
1. Create Terraform Cloud account
2. Create organization
3. Add VCS provider (github)
4. Perform terraform Login

# required envs for initial TFC magic
TF_VAR_tfe_organization_name
TF_VAR_oauth_token_id
TF_VAR_github_username
TFE_TOKEN 

5. terraform init
6. terraform apply
7. run manual apply from web ui
8. add TFE_TOKEN variable and run again
9. create HCP account including organization
10. create principal and generate token
