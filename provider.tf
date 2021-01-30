terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = var.AWS_REGION
  shared_credentials_file = var.AWS_CREDS
  profile                 = var.AWS_PROFILE
}
