terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.11.0"
    }
  }

  backend "s3" {
    bucket = "deploy.ethan.haus"
    key = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-lock"
  }
}
