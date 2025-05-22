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