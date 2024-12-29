resource "aws_route_table_association" "table_association_a" {
  for_each = local.subnets
  subnet_id      = each.value
  route_table_id = aws_route_table.route_a.id
}

