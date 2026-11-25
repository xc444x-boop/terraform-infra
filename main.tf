resource "aws_security_group" "bad_sg" {
  name        = "bad-sg"
  description = "Intentionally insecure, for scan testing"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "bad_bucket" {
  bucket = "bad-bucket-xc444x-2026"
}

resource "aws_s3_bucket_public_access_block" "bad_bucket" {
  bucket                  = aws_s3_bucket.bad_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
