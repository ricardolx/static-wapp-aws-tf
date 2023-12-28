provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "cstmr-prtl-wbp-poc01-122340"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }

}
# S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "webapp_bucket" {
 bucket = aws_s3_bucket.bucket.id

 index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}
