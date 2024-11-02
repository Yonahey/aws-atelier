# resource "aws_instance" "web1" {
#   instance_type               = var.webserver
#   ami                         = var.ami
#   subnet_id                   = aws_subnet.subnets[0].id
#   associate_public_ip_address = true
#   key_name                    = var.key
#   vpc_security_group_ids      = [aws_security_group.webserver_allow_http.id, aws_security_group.webserver_allow_ssh.id]
#   user_data                   = data.cloudinit_config.webservers.rendered
# }


# resource "aws_security_group" "webserver_allow_tls" {
#   name        = "webserver allow_tls"
#   description = "Allow TLS inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "webserver allow_tls"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "webserver_allow_tls_ipv4" {
#   security_group_id = aws_security_group.webserver_allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 443
#   ip_protocol       = "tcp"
#   to_port           = 443
# }



# resource "aws_vpc_security_group_egress_rule" "webserver_allow_tls_traffic_ipv4" {
#   security_group_id = aws_security_group.webserver_allow_tls.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
# }

# resource "aws_security_group" "webserver_allow_http" {
#   name        = "webserver allow_http"
#   description = "Allow http inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "webserver allow_http"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "webserver_allow_http_ipv4" {
#   security_group_id = aws_security_group.webserver_allow_http.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 22
#   ip_protocol       = "tcp"
#   to_port           = 22
# }



# resource "aws_vpc_security_group_egress_rule" "webserver_allow_http_all_traffic_ipv4" {
#   security_group_id = aws_security_group.webserver_allow_http.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
# }

# resource "aws_security_group" "webserver_allow_ssh" {
#   name        = "webserver allow_ssh"
#   description = "Allow http inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "webserver allow_ssh"
#   }
# }

# resource "aws_vpc_security_group_ingress_rule" "webserver_allow_ssh_ipv4" {
#   security_group_id = aws_security_group.webserver_allow_ssh.id
#   cidr_ipv4         = "0.0.0.0/0"
#   from_port         = 80
#   ip_protocol       = "tcp"
#   to_port           = 80
# }



# resource "aws_vpc_security_group_egress_rule" "webserver_allow_ssh_all_traffic_ipv4" {
#   security_group_id = aws_security_group.webserver_allow_ssh.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
# }

# #Cloud-init
# data "cloudinit_config" "webservers" {
#   gzip          = false
#   base64_encode = false


#   part {
#     filename     = "cloud-config.yml"
#     content_type = "text/cloud-config"

#     content = file("${path.module}/files/cloud-config.yml")
#   }
# }

# data "aws_availability_zones" "current" {

#   state = "available"
# }


# output "web1_public_IP" {
#   value = aws_instance.web1.public_ip
# }