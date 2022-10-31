packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ubuntu-22"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

variable "GH_ACCESS_TOKEN" {
  type = string
}


build {
  name    = "ubuntu-jammy-22"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell-local" {
    script = "hostnamectl set-hostname --static ubuntu2204 && GH_ACCESS_TOKEN=${var.GH_ACCESS_TOKEN} ../gh-actions-runner-configure.sh
  }
}
