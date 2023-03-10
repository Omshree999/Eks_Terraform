terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#configure aws provider & region

provider "aws" {
  region = "us-east-1"
}


data "aws_availability_zones" "available" {}
