# provider "aws" {
#   region  = var.region
#   profile = "default"
# }

# # create aws provider
# provider "aws" {
#   region  = "eu-west-3"
#   profile = "default"
# }


# create aws provider
provider "aws" {
  region  = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket       = "rowbucket20255050"
    use_lockfile = true
    key          = "vault-jenkins/terraform.tfstate"
    region       = "eu-west-3"
    encrypt      = true
    profile      = "default"
  }
}
