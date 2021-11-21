terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
      version = "1.0.5"
    }
  }
}

provider "boundary" {
  addr                            = "http://:9200"
  auth_method_id                  = "ampw_1234567890" # changeme
  password_auth_method_login_name = "admin"           # changeme
  password_auth_method_password   = "dodtlv2021"        # changeme
}
resource "boundary_scope" "org" {
  name                     = "DevOpsDays"
  description              = "TelAviv2021"
  scope_id                 = "global"
  auto_create_admin_role   = true
  auto_create_default_role = true
}

resource "boundary_scope" "project" {
  name                   = "Hashicorp-Terasky"
  description            = "Workshop"
  scope_id               = boundary_scope.org.id
  auto_create_admin_role = true
}

resource "boundary_host_catalog" "aws_eks" {
  type = "static"
  name = "eks services"
  scope_id = boundary_scope.project.id
}

resource "boundary_host" "boundary_host" {
  for_each = var.services

  name            = "${each.value.id}"
  type            = "static"
  description     = "${each.value.name}"
  address         = each.value.address
  host_catalog_id = boundary_host_catalog.aws_eks.id
}


resource "boundary_host_set" "eks_hosts" {
  for_each = toset(distinct([ for i,z in var.services : z.name ]))
  name = "${each.value}"
  host_catalog_id = boundary_host_catalog.aws_eks.id
  type            = "static"
  host_ids        = [for i in boundary_host.boundary_host : i.id if i.description == each.value ]
}
resource "boundary_target" "mysql_target" {
  for_each = toset([ for hs in boundary_host_set.eks_hosts: hs.name if length(regexall(".*mysql.*", hs.name )) > 0 ])
  name         = "${each.value} - 3306"
  description  = "Connect to ${each.value} service on 3306 port "
  type         = "tcp"
  scope_id     = boundary_scope.project.id
  host_source_ids =  [ for hs in boundary_host_set.eks_hosts: hs.id if hs.name == each.value ]
  default_port = "3306"
}
