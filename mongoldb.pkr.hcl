variable "ami_name" {
  type    = string
  default = "ami-mongodb-4.4"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "Scora"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "vpc_id" {
  type    = string
  default = "ubuntu"
}

variable "subnet_id" {
  type    = string
  default = "ubuntu"
}

variable "associate_public_ip" {
  type    = bool
  default = false
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "ebs" {
  ami_description             = "AMI for run mongodb server."
  ami_name                    = format("%s-%s", var.ami_name, local.timestamp)
  ami_regions                 = [var.aws_region]
  ami_virtualization_type     = "hvm"
  instance_type               = "t2.small"
  region                      = var.aws_region
  associate_public_ip_address = var.associate_public_ip

  source_ami_filter {
    filters = {
      name                = "*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = var.ssh_username
  subnet_id    = var.subnet_id
  vpc_id       = var.vpc_id

  launch_block_device_mappings {
    device_name = "/dev/sda1"
    volume_size = "8"
    volume_type = "gp2"

    delete_on_termination = true
  }
}
