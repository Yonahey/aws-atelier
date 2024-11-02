resource "aws_route_table_association" "table_association_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_a.id
}
resource "aws_route_table_association" "table_association_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_a.id
}