# AWS provider for dev environment
provider "aws" {
  alias  = "dev"
  region = "us-east-1"
}

# AWS provider for prod environment
provider "aws" {
  alias  = "prod"
  region = "us-west-2"
}
