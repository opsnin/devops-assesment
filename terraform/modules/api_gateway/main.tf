locals {
  endpoints = [
    { name = "list-games", method = "GET", description = "Retrieves a list of games" },
    { name = "create-game", method = "POST", description = "Creates a new game" },
    { name = "update-game", method = "PUT", description = "Updates an existing game" },
    { name = "external-call", method = "GET", description = "Calls an external API on the internet" }
  ]
}

resource "aws_api_gateway_rest_api" "game_api" {
  name        = "GameRESTAPI"
  description = "REST API for managing games"
}

resource "aws_api_gateway_resource" "endpoints" {
  count       = length(local.endpoints)
  rest_api_id = aws_api_gateway_rest_api.game_api.id
  parent_id   = aws_api_gateway_rest_api.game_api.root_resource_id
  path_part   = local.endpoints[count.index].name
}

resource "aws_api_gateway_method" "methods" {
  count         = length(local.endpoints)
  rest_api_id   = aws_api_gateway_rest_api.game_api.id
  resource_id   = aws_api_gateway_resource.endpoints[count.index].id
  http_method   = local.endpoints[count.index].method
  authorization = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "lambda_integrations" {
  count                   = length(local.endpoints)
  rest_api_id             = aws_api_gateway_rest_api.game_api.id
  resource_id             = aws_api_gateway_resource.endpoints[count.index].id
  http_method             = aws_api_gateway_method.methods[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.game_api.execution_arn}/*/*"
}

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

resource "aws_api_gateway_usage_plan" "game_plan" {
  name = "GameAPIUsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.game_api.id
    stage  = aws_api_gateway_stage.default.stage_name
  }
}

resource "aws_api_gateway_api_key" "game_api_key" {
  name = "GameAPIKey"
}

resource "aws_api_gateway_usage_plan_key" "game_key" {
  key_id        = aws_api_gateway_api_key.game_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.game_plan.id
}