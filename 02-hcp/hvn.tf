resource "hcp_hvn" "demo_hcp_hvn" {
  hvn_id         = "demo-hvn"
  cloud_provider = "aws"
  region         = var.region
}
