variable "ecr_repository_url" {
  type        = string
}

variable "ecr_repository_arn" {
  type        = string
}

variable "private_subnets" {
  type        = list(string)
}

variable "vpc_id" {
  type        = string
}