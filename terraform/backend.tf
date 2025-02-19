terraform {
 backend "s3" {
   bucket         = "game-tf-state"
   key            = "state/terraform.tfstate"
   region         = "ap-south-1"
  #  dynamodb_table = "las-terraform-state-locks"
 }
}