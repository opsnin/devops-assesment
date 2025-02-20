resource "aws_api_gateway_deployment" "game_api" {
  depends_on = [
    aws_api_gateway_integration.lambda_integrations
  ]

  rest_api_id = aws_api_gateway_rest_api.game_api.id
  stage_name  = ""

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.endpoints,
      aws_api_gateway_method.methods,
      aws_api_gateway_integration.lambda_integrations,
    ]))
  }
}

resource "aws_api_gateway_stage" "default" {
  deployment_id = aws_api_gateway_deployment.game_api.id
  rest_api_id   = aws_api_gateway_rest_api.game_api.id
  stage_name    = "default"
}
