output "api_endpoint" {
  value = "${aws_api_gateway_deployment.game_api.invoke_url}${aws_api_gateway_stage.default.stage_name}"
}