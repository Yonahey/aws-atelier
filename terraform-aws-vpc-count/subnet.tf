resource "aws_subnet" "subnets" {
  count  = local.subnet_count
  vpc_id = aws_vpc.main.id
  # cidr_block        = "10.1.0.0/16"
  cidr_block        = "10.1.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.current.names[count.index]

   tags = {
    Name = join("-",[local.owner, timestamp(),"${count.index}"])
  }
}

