terraform {
  required_version = ">= 1.2.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
  assume_role {
    role_arn = "arn:aws:iam::XXXX-ss-XXXX:role/tf-deployment"

  }

  default_tags {
    tags = {
      deployedBy     = "Terraform"
      terraformStack = "Shared-Infra"
    }
  }
}

provider "aws" {
  alias  = "accountz"
  region = "ap-southeast-2"
  assume_role {
    role_arn = "arn:aws:iam::XXXX-az-XXXX:role/tf-deployment"
  }

  default_tags {
    tags = {
      deployedBy     = "Terraform"
      terraformStack = "AccountZ-Infra"
    }
  }
}
