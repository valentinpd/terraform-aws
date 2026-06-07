###############################################################################
# Root module
#
# Aquí NO se definen recursos directamente: solo se "llaman" a los módulos
# de ./modules y se conectan entre sí pasando las salidas de uno como
# entradas del siguiente. La lógica de cada recurso vive dentro de su módulo.
###############################################################################

# 1) Backend de estado: bucket S3 (cifrado y versionado) + tabla DynamoDB (lock).
module "state_backend" {
  source            = "./modules/state-backend"
  project_name      = var.project_name
  state_bucket_name = var.state_bucket_name
  state_table_name  = var.state_table_name
}

# 2) Red: VPC, subred pública, internet gateway y tabla de rutas.
module "networking" {
  source             = "./modules/networking"
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# 3) Cómputo: security group + instancia EC2.
#    Recibe la red (vpc_id y subnet_id) directamente del módulo networking.
module "compute" {
  source           = "./modules/compute"
  project_name     = var.project_name
  vpc_id           = module.networking.vpc_id
  subnet_id        = module.networking.public_subnet_id
  instance_type    = var.instance_type
  ssh_allowed_cidr = var.ssh_allowed_cidr
}
