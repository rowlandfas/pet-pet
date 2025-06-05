provider "aws" {
  region  = "eu-west-1"  
}

terraform {
  backend "s3" {
    bucket       = "pet-adoption-state-bucket-1"
    use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
  }
}

provider "vault" {
  address = "https://vault.set30.space"
  token = "hvs.3dg3XN6aX7aLCO9RQt5RdTdf"
}