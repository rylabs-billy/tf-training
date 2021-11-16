# terraform_module_project/providers.tf

terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
  required_version = ">= 0.13"
}