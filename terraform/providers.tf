terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.env.region
  default_tags {
    tags = var.env
  }
}

terraform {
  required_version = "1.5.5"
}