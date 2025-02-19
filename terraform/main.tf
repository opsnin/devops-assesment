provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = var.common_tags
  }
}

data "aws_caller_identity" "current" {}

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
    "private-subnet"           = "true"
  }
  public_subnet_tags = {
    "public-subnet"            = "true"
  }
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${var.project_name}-api"
}

module "lambda" {
  source               = "./modules/lambda"
  vpc_id               = module.vpc.vpc_id
  private_subnets      = module.vpc.private_subnets
  ecr_repository_url   = module.ecr.repository_url
  ecr_repository_arn   = module.ecr.repository_arn
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
}