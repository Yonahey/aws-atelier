resource "aws_subnet" "subnets" {
  count  = local.subnet_count
  vpc_id = aws_vpc.main.id
  cidr_block        = cidrsubnet("10.1.0.0/16", 8, count.index)
  availability_zone = data.aws_availability_zones.current.names[count.index]

   tags = {
    Name = format("%s-%s-%d", local.name, local.current_date, count.index)
  }
}

