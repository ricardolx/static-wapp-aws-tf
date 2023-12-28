# Deploy the SAM template
resource "auth_stack" "sam_stack" {
  name = "sam-stack"

  template_body = file("${path.module}/template.yaml")

  parameters = {
    AuthEdge = "auth-edge",
    AuthGateway = "auth-gateway",
  }

  capabilities = ["CAPABILITY_IAM"]
}