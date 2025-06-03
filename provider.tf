provider "aws" {
  region  = "eu-west-1"
  profile = ""
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