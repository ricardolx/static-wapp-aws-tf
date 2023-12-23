

provider "aws" {
  region = "us-east-1"
}

# S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "webapp_bucket" {
  bucket = "cstm-prtl-wbp-bck039028-sfkf924"
#   acl    = "public-read"

}

# # Lambda function to retrieve web app from S3
# resource "aws_lambda_function" "webapp_lambda" {
#   function_name = "webapp-lambda"
#   handler      = "index.handler"
#   runtime      = "nodejs18.x"
#   timeout      = 10

#   source_code_hash = filebase64("${path.module}/path/to/your/lambda/code.zip")

#   environment {
#     variables = {
#       BUCKET_NAME = aws_s3_bucket.webapp_bucket.bucket
#     }
#   }
# }

# Application Load Balancers
# resource "aws_lb" "webapp_lb" {
#   name               = "webapp-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = ["your-security-group-id"]
#   subnets            = ["your-public-subnet-1", "your-public-subnet-2"]

#   enable_deletion_protection = false
# }

# # CloudFront distribution with WAF
# resource "aws_cloudfront_distribution" "webapp_distribution" {
#   origin {
#     domain_name = aws_lb.webapp_lb.dns_name
#     origin_id   = aws_lb.webapp_lb.id
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   default_root_object = "index.html"

#   aliases = ["your-cloudfront-alias"]

#   # Add other CloudFront configuration settings as needed

#   default_cache_behavior {
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = aws_lb.webapp_lb.id

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   # WAF configuration (create AWS WAF WebACL before using it here)
#   web_acl_id = "your-waf-webacl-id"
# }

# # AWS API Gateway
# resource "aws_api_gateway_rest_api" "webapp_api" {
#   name        = "webapp-api"
#   description = "Web App API"
# }

# resource "aws_api_gateway_resource" "webapp_resource" {
#   rest_api_id = aws_api_gateway_rest_api.webapp_api.id
#   parent_id   = aws_api_gateway_rest_api.webapp_api.root_resource_id
#   path_part   = "webapp"
# }

# resource "aws_api_gateway_method" "webapp_method" {
#   rest_api_id   = aws_api_gateway_rest_api.webapp_api.id
#   resource_id   = aws_api_gateway_resource.webapp_resource.id
#   http_method   = "GET"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "webapp_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.webapp_api.id
#   resource_id             = aws_api_gateway_resource.webapp_resource.id
#   http_method             = aws_api_gateway_method.webapp_method.http_method
#   integration_http_method = "POST"

#   uri = aws_lambda_function.webapp_lambda.invoke_arn
# }

# resource "aws_api_gateway_deployment" "webapp_deployment" {
#   depends_on = [aws_api_gateway_integration.webapp_integration]

#   rest_api_id = aws_api_gateway_rest_api.webapp_api.id
#   stage_name  = "prod"
# }
