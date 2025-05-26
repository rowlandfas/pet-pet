locals {
  name = "team-1"
}

module "vpc" {
  source = "./module/vpc"
  name   = local.name
  az1    = "eu-west-1a"
  az2    = "eu-west-1b"
}

module "bastion" {
  source      = "./module/bastion"
  name        = local.name
  vpc         = module.vpc.vpc_id
  subnets  = [module.vpc.pub_sub1_id, module.vpc.pub_sub2_id]
  keypair     = module.vpc.public_key
  privatekey = module.vpc.private_key
  nr-acc-id = var.nr-acc-id
  nr-key = var.nr-key
}

# module "ansible" {
#   source    = "./module/ansible"
#   name      = local.name
#   keypair   = module.vpc.public_key
#   subnet_id = module.vpc.pri_sub1_id
#   vpc       = module.vpc.vpc_id
#   bastion   = ""
#   private-key = module.vpc.private_key
#   deployment = ""
#   prod-bashscript = "./module/ansible/prod-bashscript.sh" # Path to the prod bash script
#   stage-bashscript = "./module/ansible/stage-bashscript.sh" # Path to the stage bash script
#   nexus-ip = ""
#   nr-key = ""
#   nr-acc-id = ""
# }

module "sonarqube" {
  source = "./module/sonarqube"
  name = local.name
  vpc = module.vpc.vpc_id
  vpc_cidr_block = "10.0.0.0/16"
  keypair = module.vpc.public_key
  subnet_id = module.vpc.pub_sub1_id
  
}