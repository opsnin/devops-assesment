variable "region_azs" {
  type        = list(string)
  description = "List of Availability Zone letters (e.g., ['a', 'b', 'c'])"

  validation {
    condition     = length(var.region_azs) > 0
    error_message = "At least one Availability Zone letter must be specified."
  }

  validation {
    condition = alltrue([
      for az in var.region_azs : can(regex("^[a-z]$", az))
    ])
    error_message = "Each Availability Zone must be a single lowercase letter (e.g., 'a', 'b', 'c')."
  }
}

variable "num_public_subnets" {
  type        = number
  description = "The number of public subnets to create"

  validation {
    condition     = var.num_public_subnets >= 1
    error_message = "At least one public subnet must be created."
  }
}

variable "num_private_subnets" {
  type        = number
  description = "The number of private subnets to create"

  validation {
    condition     = var.num_private_subnets >= 1
    error_message = "At least one private subnet must be created."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC"

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]+$", var.vpc_cidr))
    error_message = "VPC CIDR block must be in the correct format, e.g., '10.0.0.0/16'."
  }
}

variable "project_name" {
  type        = string
  description = "The name of the project"

  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name cannot be empty."
  }

  validation {
    condition     = length(var.project_name) <= 50
    error_message = "Project name must not exceed 50 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.project_name))
    error_message = "Project name can only contain letters, numbers, hyphens (-), and underscores (_)."
  }
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Whether to create a single NAT gateway instead of one per public subnet"
}

variable "create_vpc_flow_log" {
  type        = bool
  default     = false
  description = "Whether to create a VPC Flow Log"
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}
