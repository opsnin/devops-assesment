resource "aws_api_gateway_usage_plan" "game_plan" {
  name = "GameAPIUsagePlan"

  api_stages {
    api_id = aws_api_gateway_rest_api.game_api.id
    stage  = aws_api_gateway_stage.default.stage_name
  }

  throttle_settings {
    rate_limit  = 10 
    burst_limit = 20 
  }

  quota_settings {
    limit  = 1000
    period = "MONTH"
  }
}