terraform {
  #   backend "s3" {
  #     bucket = "terraform-state-backet"
  #     encrypt = true
  #     key = "ec2/terraform.tfstate"
  #     region = "us-east-1"
  #     dynamodb_table = "terraform_stake_lock"
  # }
  required_providers {
    aws = {
      version = "~>3.0"
    }
    tls = {
      version = "~>3.0"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  profile                  = "user"
  shared_credentials_file = "~/.aws/credentials"
  region                   = "us-east-1"

}
