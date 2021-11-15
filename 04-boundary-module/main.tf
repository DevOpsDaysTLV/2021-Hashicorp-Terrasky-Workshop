terraform {
  required_providers {
    boundary = {
      source = "hashicorp/boundary"
      version = "1.0.5"
    }
  }
}

provider "boundary" {
  addr                            = "http://:9200"
  auth_method_id                  = "ampw_1234567890" # changeme
  password_auth_method_login_name = "admin"          # changeme
  password_auth_method_password   = "password"        # changeme
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

resource "boundary_host_catalog" "static" {
      type        = "static"

  scope_id = boundary_scope.project.id
}

resource "boundary_host" "boundary_host" {
for_each = var.services

  name            = "${each.key}-${each.value.node}"
  type            = "static"
  description     = "${each.value.node}"
  address         = "${each.value.node_address}"
  host_catalog_id = boundary_host_catalog.static.id
}

resource "boundary_host_set" "boundary_host_set" {
  host_catalog_id = boundary_host_catalog.static.id
  type            = "static"
  host_ids = [for i in boundary_host.boundary_host : i.id]
}

resource "boundary_target" "boundary_target" {
  name         = "Nomad Clients"
  description  = "SSH"
  type         = "tcp"
  default_port = "22"
  scope_id     = boundary_scope.project.id
  host_source_ids = [
    boundary_host_set.boundary_host_set.id
  ]
}

