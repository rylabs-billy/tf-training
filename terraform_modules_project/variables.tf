# terraform_modules_project/variables.tf 

variable "authorized_keys" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG925acs9OB9+u1XKZmJRcZ4KIQjzIQAUZ2lGSAoSn6X bthompson@linode.com"
}

variable "region" {
  default = "us-central"
}

variable "amount" {
  default = "3"
}

variable "api_token" {}

variable "root_pass" {}