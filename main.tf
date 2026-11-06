module "networking" {
  source             = "./modules/networking"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "compute" {
  source             = "./modules/compute"
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_app_subnet_ids
}

module "database" {
  source             = "./modules/database"
  project_name       = var.project_name
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_db_subnet_ids
  app_security_group = module.compute.app_security_group_id
}
