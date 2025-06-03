# provider "aws" {
#   region  = var.region
#   profile = "bukky_int"
# }

# # create aws provider
# provider "aws" {
#   region  = "eu-west-3"
#   profile = "Lington"
# }


# create aws provider
provider "aws" {
  region  = var.region
  profile = "pet-adoption"
}

terraform {
  backend "s3" {
    bucket       = "pet-adoption-state-bucket-1"
    use_lockfile = true
    key          = "vault-jenkins/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    profile      = "pet-adoption"
  }
}