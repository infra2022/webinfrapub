terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "terra-state-10202022"
    key    = "dev"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = var.region
  secret_key = "UseRole"
  access_key = "UseRole"
}