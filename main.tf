terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "terraform-state-xc444x-2026"
    key          = "demo/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }

  required_providers {s
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-gh-actions-demo"
  }
}
