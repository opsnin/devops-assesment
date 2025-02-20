resource "aws_api_gateway_integration" "lambda_integrations" {
  count                   = length(var.endpoints)
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
  for_each = { for idx, ep in var.endpoints : idx => ep }

  statement_id  = "AllowExecutionFromAPIGateway-${each.value.name}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.game_api.execution_arn}/*/${each.value.method}/${each.value.name}"
}