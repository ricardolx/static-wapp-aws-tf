

# AWS API Gateway
resource "aws_api_gateway_rest_api" "webapp_api" {
  name        = "webapp-api"
  description = "Web App API"
}

resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "my_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_resource.id
  http_method = aws_api_gateway_method.my_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_cloudformation_stack.auth_stack.outputs["AuthGatewayLambdaArn"]
}

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
