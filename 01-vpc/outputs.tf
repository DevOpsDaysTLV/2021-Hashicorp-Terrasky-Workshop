output "cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "vpc_owner_id" {
  value = module.vpc.vpc_owner_id
}

output "private_key" {
  value = tls_private_key.dodworkshop.private_key_pem
}
