region_azs          = ["a", "b", "c"]
project_name        = "game-api"
num_public_subnets  = 3
num_private_subnets = 3
vpc_cidr            = "172.40.0.0/16"
lambda_function_name = "game-api"
restapi_name         = "GameRESTAPI"
common_tags = {
  "Project-Name" = "game-api"
  "Managed-By"   = "Terraform"
  "Environment"  = "Production"
  "Owner"        = "Janam-Khatiwada"
}