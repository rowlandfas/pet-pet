provider "aws" {
  region  = "eu-west-3"
  # profile = "pet-adoption"
}

terraform {
  backend "s3" {
    bucket       = "pet-adoption-state-bucket-1133313317711lington"
    use_lockfile = true
    key          = "infrastructure/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    # profile      = "pet-adoption"
  }
}

provider "vault" {
  address = "https://vault.3ureka.com"
  token   = "hvs.zuawemqhSXtLuok9Sa7Y7ybh" }
