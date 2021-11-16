terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "burdandrei"

    workspaces {
      name = "VPC"
    }
  }
}
