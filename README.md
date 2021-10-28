# Terraform training

### Getting started

Install VS Code and Terraform:
```
brew install visual-studio terraform ansible
```
Crate a new `ssh` key pair to use with Terraform.
```
ssh-keygen -o -a 100 -t ed25519 -C "terraform" -f "${HOME}/.ssh/id_terraform_ed25519" -q -N "" <<<y >/dev/null
```

Create a Linode API token in the [Cloud Manager](https://www.linode.com/docs/guides/getting-started-with-the-linode-api/#get-an-access-token), copy it, and then type the following to save it in a temporary location.
```
pbpaste > /tmp/tf.key
```

Generate a random root password to use with Terraform.
```
openssl rand -base64 32 > /tmp/tf.pw
```

### Into to Terraform
Analyze the Terraform files in the `terraform_project` directory. The `main.tf` file contains the main set of configuration for your module.
```
provider "linode" {
  token = var.api_token
}

resource "linode_instance" "web" {
  count = var.amount
  image = "linode/debian10"
  label = "TF-${count.index + 1}"
  group = "terraform_group"
  tags = ["Terraform-Training"]
  region = var.region
  type = "g6-standard-1"
  authorized_keys = [ var.authorized_keys ]
  root_pass = var.root_pass
}
```

Notice these are linode instance parameters, and we substituted four values with variables:
- token = `var.api_token` - Your Linode API token
- count = `var.amount` - The number of Linodes to stand up
- region = `var.region` - The region to deploy Linodes
- authorized_keys = `[ var.authorized_keys ]` - Your public ssh key to put in the `authorized_keys` file.
- root_pass = `var.root_pass` - Root password for Linodes

This demonstrates how we can use variables in the `main.tf` file. We can declare variables and any defaults in this same file under the `resource` block, or we can organize them in a separate `variables.tf` file. 
```
variable "authorized_keys" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG925acs9OB9+u1XKZmJRcZ4KIQjzIQAUZ2lGSAoSn6X bthompson@linode.com"
}

variable "region" {
  default = "ap-southeast"
}

variable "amount" {
  default = "3"
}

variable "api_token" {}

variable "root_pass" {}
```

Then place the values in a `terraform.tfvars` file. Putting sensitve values here will make Terraform mask them when displaying output in the terminal (displayed as "sensitive value").
```
api_token = "<YOUR_API_TOKEN>"
root_pass ="<YOUR_ROOT_PASSWORD>"
```

At this point the Linode IDs of our future instances are still to be determined, so let's configure a `outputs.tf` file to display them after Terraform executes successfully. 
```
output "linode_id" {
    value = linode_instance.web.*.id
}
```

Using the Terraform CLI, initialize your project.
```
terraform init
```

Verify that Terraform will create the resources as expected.
```
terraform plan
```

A successful plan looks something like the output below.
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # linode_instance.web[0] will be created
  + resource "linode_instance" "web" {
      + authorized_keys    = [
          + "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG925acs9OB9+u1XKZmJRcZ4KIQjzIQAUZ2lGSAoSn6X bthompson@linode.com",
        ]
      + backups            = (known after apply)
      + backups_enabled    = (known after apply)
      + boot_config_label  = (known after apply)
      + group              = "terraform_group"
      + id                 = (known after apply)
      + image              = "linode/debian10"
      + ip_address         = (known after apply)
      + ipv4               = (known after apply)
      + ipv6               = (known after apply)
      + label              = "TF-1"
      + private_ip_address = (known after apply)
      + region             = "ap-southeast"
      + root_pass          = (sensitive value)
      + specs              = (known after apply)
      + status             = (known after apply)
      + swap_size          = (known after apply)
      + tags               = [
          + "Terraform-Training",
        ]
      + type               = "g6-standard-1"
      + watchdog_enabled   = true

      + alerts {
          + cpu            = (known after apply)
          + io             = (known after apply)
          + network_in     = (known after apply)
          + network_out    = (known after apply)
          + transfer_quota = (known after apply)
        }
    }

  # linode_instance.web[1] will be created
  + resource "linode_instance" "web" {
      + authorized_keys    = [
          + "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG925acs9OB9+u1XKZmJRcZ4KIQjzIQAUZ2lGSAoSn6X bthompson@linode.com",
        ]
      + backups            = (known after apply)
      + backups_enabled    = (known after apply)
      + boot_config_label  = (known after apply)
      + group              = "terraform_group"
      + id                 = (known after apply)
      + image              = "linode/debian10"
      + ip_address         = (known after apply)
      + ipv4               = (known after apply)
      + ipv6               = (known after apply)
      + label              = "TF-2"
      + private_ip_address = (known after apply)
      + region             = "ap-southeast"
      + root_pass          = (sensitive value)
      + specs              = (known after apply)
      + status             = (known after apply)
      + swap_size          = (known after apply)
      + tags               = [
          + "Terraform-Training",
        ]
      + type               = "g6-standard-1"
      + watchdog_enabled   = true

      + alerts {
          + cpu            = (known after apply)
          + io             = (known after apply)
          + network_in     = (known after apply)
          + network_out    = (known after apply)
          + transfer_quota = (known after apply)
        }
    }

  # linode_instance.web[2] will be created
  + resource "linode_instance" "web" {
      + authorized_keys    = [
          + "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG925acs9OB9+u1XKZmJRcZ4KIQjzIQAUZ2lGSAoSn6X bthompson@linode.com",
        ]
      + backups            = (known after apply)
      + backups_enabled    = (known after apply)
      + boot_config_label  = (known after apply)
      + group              = "terraform_group"
      + id                 = (known after apply)
      + image              = "linode/debian10"
      + ip_address         = (known after apply)
      + ipv4               = (known after apply)
      + ipv6               = (known after apply)
      + label              = "TF-3"
      + private_ip_address = (known after apply)
      + region             = "ap-southeast"
      + root_pass          = (sensitive value)
      + specs              = (known after apply)
      + status             = (known after apply)
      + swap_size          = (known after apply)
      + tags               = [
          + "Terraform-Training",
        ]
      + type               = "g6-standard-1"
      + watchdog_enabled   = true

      + alerts {
          + cpu            = (known after apply)
          + io             = (known after apply)
          + network_in     = (known after apply)
          + network_out    = (known after apply)
          + transfer_quota = (known after apply)
        }
    }

Plan: 3 to add, 0 to change, 0 to destroy.
```

You can optionally pass `-out <file>` to the `terraform plan` command to save the plan to a file, and use `terraform show` to inspect the plan before applying. This may be preferred to avoid accidentally destroying/modifying resources.
```
terraform plan -out linode-plan
terraform show linode-plan
```

If all looks good, `apply` the plan! Terraform will proceed with exactly the steps outlined in the plan file. In the absence of a plan file, it will prompt the user for approval.
```
terraform apply linode-plan
```

### Add VLAN
To update the linodes to use VLANs, we need to do more than the basic configuration/deployment. The Linode Terraform provider allows us to use explicit disks and configs. They are both required to use the `interface` block for the VLAN configuration. Update your `main.tf` file to match the below example.
```
provider "linode" {
  token = var.api_token
}

#linodes
resource "linode_instance" "web" {
  count = var.amount
  #image = "linode/debian10"
  label = "TF-${count.index + 1}"
  group = "terraform_group"
  tags = ["Terraform-Training"]
  region = var.region
  type = "g6-standard-1"
  private_ip = true

  disk {
    label = "Debian 10 Disk" # required
    size = 50688 
    image  = "linode/debian10"
    authorized_keys = [ var.authorized_keys ]
    root_pass = var.root_pass
  }

  disk {
    label = "512 MB Swap Image" # required
    size = 512
    filesystem = "swap"
  }

  config {
    label = "My Debian 10 Disk Profile" # required
    devices {
      sda {
        disk_label = "Debian 10 Disk"
      }
      sdb {
        disk_label = "512 MB Swap Image"
      }
    }
    interface {
      purpose = "public"
      label = ""
    }
    interface {
      purpose = "vlan"
      label = "eth1"
      ipam_address = "10.0.0.${count.index + 1}/24"
    }
  }
}
```

Notice that the `image`, `authorized_keys`, and `root_pass` parameters were moved into the `disk` block, instead of the root of the `linode_instance` resource. We also have to explicitly create and size each disk, as well as create the configuration profile for the Linode to boot from. Terraform will destroy and rebuild these Linodes, since this process requires rebuilding the disks. We'll writ this plan to a new file titled `linode-vlan-plan` and then `apply` if everything looks as we want it.
```
terraform plan
terraform apply
```

# Add Cloud Firewall
Now we're going to add another resource block that configures a Cloud Firewall and then attaches it to the three Linodes. Append the the below to the `main.tf` file, `plan it`, and `apply` it.
```
# firewall
resource "linode_firewall" "web_firewall" {
  label = "TF-firewall"
  tags  = ["Terraform-Training"]

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-https"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "443"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound {
    label    = "allow-vlan-tcp"
    action   = "ACCEPT"
    protocol = "TCP"
    ipv4     = ["10.0.0.0/24"]
  }

  inbound {
    label    = "allow-vlan-udp"
    action   = "ACCEPT"
    protocol = "UDP"
    ipv4     = ["10.0.0.0/24"]
  }

  inbound {
    label    = "allow-icmp"
    action   = "ACCEPT"
    protocol = "ICMP"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["::/0"]
  }

  inbound_policy = "DROP"
  outbound_policy = "ACCEPT"

  linodes = linode_instance.web.*.id
}
```
```
terraform plan
terraform apply
```

### Add NodeBalancer

Alrighty! Let's put the three Linodes behind a NodeBalancer! This requires defining three more `resources` as well, one to create the NodeBalancer instance, one for its configuration, and another known as a **_"NodeBalancer Node"_** resource that ties everything together. You can think of this as the part that defines the relationship between the nodes, NodeBalancer and it's configuration.

```
# nodebalancer
resource "linode_nodebalancer" "web_nodebalancer" {
    label = "web_nodebalancer"
    region = var.region
}

resource "linode_nodebalancer_config" "web_nodebalancer_config" {
    nodebalancer_id = linode_nodebalancer.web_nodebalancer.id
    port = 80
    protocol = "http"
    check = "http"
    check_path = "/"
    check_attempts = 3
    check_timeout = 5
    check_interval = 10
    stickiness = "http_cookie"
    algorithm = "roundrobin"
}

resource "linode_nodebalancer_node" "web_nodebalancer_node" {
    count = var.amount
    nodebalancer_id = linode_nodebalancer.web_nodebalancer.id
    config_id = linode_nodebalancer_config.web_nodebalancer_config.id
    address = "${element(linode_instance.web.*.private_ip_address, count.index)}:80"
    label = "web_nodebalancer_node"
    weight = 50
}
```
```
terraform plan
terraform apply
```
### Config Management
You will notice the NodeBalancer is reporting that all nodes are **_down_**. Well, that's because we haven't installed and configured a web server on them yet. Let's change that! We'll define some commands to install and configure `nginx` on our Linodes, by using `provisioners`. These are used to execute commands either locally (`local-exec`), on the remote nodes (`remote-exec`), or to copy files to the remote nodes (`file`). We could define these provisioners within the `` resource, but for this example we'll put them in a `null_resource` at then end of our `main.tf` file. A `null_resource` allows us to configure connection details and provisioners, and run those provisioners without being directly associated with another resource.

> Note: Terraform documentation states that [Provisioners are a Last Resort](https://www.terraform.io/docs/language/resources/provisioners/syntax.html), and they recommend [cloud-init](https://learn.hashicorp.com/tutorials/terraform/cloud-init?in=terraform/provision&utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS) or [packer](https://learn.hashicorp.com/tutorials/terraform/packer?in=terraform/provision&utm_source=WEBSITE&utm_medium=WEB_IO&utm_offer=ARTICLE_PAGE&utm_content=DOCS) for configuration management.
```
# configure web nodes
resource "null_resource" "install_nginx" {
  count = var.amount
  provisioner "file" {
    source      = "nginx/index.html"
    destination = "/tmp/index.html"

    connection {
      type = "ssh"
      user = "root"
      agent = "true"
      host = "${element(linode_instance.web.*.ip_address, count.index)}"
    }  
  }

    provisioner "file" {
    source      = "nginx/example.com.conf"
    destination = "/tmp/example.com.conf"

    connection {
      type = "ssh"
      user = "root"
      agent = "true"
      host = "${element(linode_instance.web.*.ip_address, count.index)}"
    }  
  }

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "mkdir -p /var/www/html",
      "apt -y install nginx",
      "mv /tmp/index.html /var/www/html/index.html",
      "chown -R www-data: /var/www/html/",
      "mv /tmp/example.com.conf /etc/nginx/sites-available/example.com.conf",
      "cd /etc/nginx/sites-enabled/",
      "ln -s ../sites-available/example.com.conf example.com.conf",
      "systemctl restart nginx"
    ]
    connection {
      type = "ssh"
      user = "root"
      agent = "true"
      host = "${element(linode_instance.web.*.ip_address, count.index)}"
    }  
  }  
}
```
```
terraform plan
terraform apply
```

The Linode way to do the above would be to use a StackScript with the `linode_instance` resource. Below is an [example](https://www.linode.com/docs/guides/deploy-a-wordpress-site-using-terraform-and-linode-stackscripts/#examining-the-terraform-configuration) of that looks like.
> Note: This is just an example of adding stackscript parameters to the `linode_instance` resource. We did not configure the variables for this, and thus we are not doing it as part of this lab. I repeat, the below is just an example - DO NOT add this to your `main.tf`.
```
#linodes
resource "linode_instance" "web" {
  count = var.amount
  #image = "linode/debian10"
  label = "TF-${count.index + 1}"
  group = "terraform_group"
  tags = ["Terraform-Training"]
  region = var.region
  type = "g6-standard-1"
  private_ip = true

  disk {
    label = "Debian 10 Disk" # required
    size = 50688 
    image  = "linode/debian10"
    authorized_keys = [ var.authorized_keys ]
    root_pass = var.root_pass
    stackscript_id = 12345
    stackscript_data = {
      "ssuser" = var.stackscript_data["ssuser"]
      "hostname" = var.stackscript_data["hostname"]
      "website" = var.stackscript_data["website"]
      "dbuser" = var.stackscript_data["dbuser"]
      "db_password" = var.stackscript_data["db_password"]
      "sspassword" = var.stackscript_data["sspassword"]
      "dbuser_password" = var.stackscript_data["dbuser_password"]
    }
  }

  disk {
    label = "512 MB Swap Image" # required
    size = 512
    filesystem = "swap"
  }

  config {
    label = "My Debian 10 Disk Profile" # required
    devices {
      sda {
        disk_label = "Debian 10 Disk"
      }
      sdb {
        disk_label = "512 MB Swap Image"
      }
    }
    interface {
      purpose = "public"
      label = ""
    }
    interface {
      purpose = "vlan"
      label = "eth1"
      ipam_address = "10.0.0.${count.index + 1}/24"
    }
  }
}
```

### Combining with Ansible
Terraform use to provide support for vendor provisioners, including Ansible, Chef, Puppet, Salt, etc. Newer versions of Terraform have deprecated them, since they on making you use packer instead. TO use Ansible with Terraform, you can either have packer call Ansible playbooks, or the `local-exec` provisioner that we mentioned earlier. The latter is what we're doing below.
```
# ansible provisioner
resource "null_resource" "ansible" {
  count = var.amount
  provisioner "local-exec" {
  command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${element(linode_instance.web.*.ip_address, count.index)},' -e 'pub_key=${var.authorized_keys}' ansible/install.yml"

    connection {
      type = "ssh"
      user = "root"
      agent = "true"
      host = "${element(linode_instance.web.*.ip_address, count.index)}"
    }  
  }
}
```
```
terraform plan
terraform apply
```

Is that all? Hell naw!! Let's deploy an LKE cluster while we're at it. Append the below resource to your `main.tf` file.
```
# lke cluster
resource "linode_lke_cluster" "web_lke_cluster" {
    label       = "web_lke_cluster"
    k8s_version = "1.20"
    region      = var.region
    tags        = ["Terraform-Training"]

    pool {
        type  = "g6-standard-2"
        count = 3
    }
}
```
```
terraform plan
terraform apply
```

# Terraform Modules
By now you'll notice that the `main.tf` file is starting to get long. It will start to become strenuous and increasingly less manageable the more we add to it from here. This is where **modules** come to the rescue! We can modularize all of this into more digestible, bite size chunks that are simple to manage. You might not see the night and day difference in this example, but as your infrastructure grows and becomes more complex, you most certainly will! We will pick that up in part 2 of this lesson.


