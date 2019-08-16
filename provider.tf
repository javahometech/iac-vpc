provider "aws" {
  region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket  = "912090126823-terraform-remote-state-storage"
    key     = "ecs/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}
