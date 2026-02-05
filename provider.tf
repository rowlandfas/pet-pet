provider "aws" {
  region  = "eu-west-3"
  # profile = "pet-adoption"
}

terraform {
  backend "s3" {
    bucket       = "rowbucket20255050"
    # use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    # profile      = "default"
  }
}

provider "vault" {
  address = "https://vault.seyi-prj2025.space"
  token   = "hvs.9PLe9wBoncORIt2D7paTnfvg" 
}
