curl \
  --header "Authorization: Bearer ${TF_VAR_tfc_token}" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @varsets.json \
  https://app.terraform.io/api/v2/organizations/${TF_VAR_tfc_organization_name}/varsets