terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }

    vercel = {
      source  = "vercel/vercel"
      version = "~> 2.9"
    }
  }

  backend "s3" {
    bucket         = "deploy.ethan.haus"
    key            = "terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform_lock"
  }
}
