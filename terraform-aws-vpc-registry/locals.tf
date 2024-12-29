locals {
 subnets = {
    s1 = aws_subnet.subnet_a.id
    s2 = aws_subnet.subnet_b.id
  }
}