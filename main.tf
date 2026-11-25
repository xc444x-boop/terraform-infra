terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "terraform-state-xc444x-2026"
    key          = "demo/terraform.tfstate"
    region       = "eu-north-1"
    use_lockfile = true
  }

  required_providers {
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

resource "aws_s3_bucket" "app_data" {
  bucket = "app-data-xc444x-2026"
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket                  = aws_s3_bucket.app_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_data" {
  bucket = aws_s3_bucket.app_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Web security group"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "HTTPS from inside the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
