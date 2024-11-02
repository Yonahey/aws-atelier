resource "aws_route_table_association" "main" {
  for_each  = aws_subnet.subnets
  subnet_id = each.value.id
  route_table_id = aws_route_table.main.id
}
# resource "aws_route_table_association" "table_association_b" {
#   subnet_id      = aws_subnet.subnet_b.id
#   route_table_id = aws_route_table.route_a.id
# }