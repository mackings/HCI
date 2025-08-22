terraform {
  required_version = ">= 1.7.0"

  # cloud {
  #   organization = "hug-ibadan-demo" # <-- change to your HCP Terraform org (cannot be a variable)
  #   workspaces {
  #     name = "netlify-static"        # <-- change to your HCP Terraform workspace (cannot be a variable)
  #   }
  # }

  required_providers {
    netlify = {
      source  = "netlify/netlify"
      version = ">= 0.2.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
  }
}
