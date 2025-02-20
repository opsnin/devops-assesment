resource "aws_api_gateway_rest_api" "game_api" {
  name = var.restapi_name
}

resource "aws_api_gateway_resource" "endpoints" {
  count       = length(var.endpoints)
  rest_api_id = aws_api_gateway_rest_api.game_api.id
  parent_id   = aws_api_gateway_rest_api.game_api.root_resource_id
  path_part   = var.endpoints[count.index].name
}

resource "aws_api_gateway_method" "methods" {
  count            = length(var.endpoints)
  rest_api_id      = aws_api_gateway_rest_api.game_api.id
  resource_id      = aws_api_gateway_resource.endpoints[count.index].id
  http_method      = var.endpoints[count.index].method
  authorization    = "NONE"
  api_key_required = true

  request_parameters = {
    "method.request.path.proxy" = true
  }
}