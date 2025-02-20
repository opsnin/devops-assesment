provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = var.common_tags
  }
}