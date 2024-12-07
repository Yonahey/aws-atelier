resource "aws_instance" "EC2" {
  count = var.instance_count
  instance_type = "t3.micro"
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.subnet_id
  tags = {
    name = "${var.instance_name_tag}-${count.index}"
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


