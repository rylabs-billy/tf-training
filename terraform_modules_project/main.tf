# terraform_modules_project/main.tf

provider "linode" {
    token = var.api_token
}