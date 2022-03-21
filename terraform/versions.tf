terraform {
  required_version = ">=0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.32.0"
    }
    null = "~> 3.1.0"
  }
}
