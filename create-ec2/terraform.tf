terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" #configuration supports any version of the provider with a major version of 5 and minor ver greater than or equal to 6.0		
    }
  }
  required_version = ">= 1.15"
}
