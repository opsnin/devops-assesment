resource "aws_api_gateway_api_key" "game_api_key" {
  name = "GameAPIKey"
}

resource "aws_api_gateway_usage_plan_key" "game_key" {
  key_id        = aws_api_gateway_api_key.game_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.game_plan.id
}
