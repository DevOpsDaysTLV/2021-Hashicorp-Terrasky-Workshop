variable "region" {
  description = "The region of the HCP HVN and Vault cluster."
  type        = string
  default     = "eu-central-1"
}

variable "tfc_organization_name" {
  type = string
}
