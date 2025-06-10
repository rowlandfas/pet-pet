provider "aws" {
  region  = "eu-west-1"
  # profile = "pet-adoption"
}

terraform {
  backend "s3" {
    bucket       = "pet-adoption-state-bucket-1"
    use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    # profile      = "pet-adoption"
  }
}

provider "vault" {
  address = "https://vault.set30.space"
  token   = "hvs.Ml9bSixTf6RXj68efpeJub6D" 
}