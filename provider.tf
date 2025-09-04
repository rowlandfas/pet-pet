provider "aws" {
  region  = "eu-west-3"
  # profile = "pet-adoption"
}

terraform {
  backend "s3" {
    bucket       = "rowbucket2025"
    # use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    # profile      = "default"
  }
}

provider "vault" {
  address = "https://vault.selfdevops.space"
  token   = "hvs.81Px0Yfb6VFAGhyS6zjCcgw2" 
}
