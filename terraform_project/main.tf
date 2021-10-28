provider "linode" {
  token = var.api_token
}

resource "linode_instance" "web" {
  count = var.amount
  image = "linode/debian10"
  label = "${var.label_prefix}${count.index + 1}"
  group = "terraform_group"
  tags = ["Terraform-Training"]
  region = var.region
  type = "g6-standard-1"
  authorized_keys = [ var.authorized_keys ]
  root_pass = var.root_pass
}
