output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "private_app_subnet_ids" {
  value = module.vpc.private_subnets
}

output "private_db_subnet_ids" {
  value = module.vpc.database_subnets
}
