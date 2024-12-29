resource "aws_instance" "EC2" {
  for_each = var.subnets
  instance_type = "t3.micro"
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = each.value
  tags = {
    name = "${var.instance_name_tag}-${each.key}"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


