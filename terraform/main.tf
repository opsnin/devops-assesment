module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  region_azs          = var.region_azs
  num_public_subnets  = var.num_public_subnets
  num_private_subnets = var.num_private_subnets
  project_name        = local.project_name
  create_vpc_flow_log = true
  single_nat_gateway  = false
  private_subnet_tags = {
    "private-subnet" = "true"
  }
  public_subnet_tags = {
    "public-subnet" = "true"
  }
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${var.project_name}"
  aws_region        = data.aws_region.current.name  
}

module "lambda" {
  source             = "./modules/lambda"
  lambda_function_name   = var.lambda_function_name
  aws_region         = data.aws_region.current.name
  aws_account_id     = data.aws_caller_identity.current.account_id  
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
  ecr_repository_url = module.ecr.repository_url
  ecr_repository_arn = module.ecr.repository_arn
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  restapi_name         = var.restapi_name
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
  endpoints            = local.endpoints
}