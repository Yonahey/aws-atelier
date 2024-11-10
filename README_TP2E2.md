# TP1E1-terraform-aws-vpc

## Instructions

Dans un nouveau répertoire nommé terraform-aws-vpc-web

- Créer une configuration terraform qui déploie les mêmes ressources que le TP1E1.

- Déployer un serveur web avec le template de votre choix (html5up), accessible depuis un navigateur en HTTP.

Vous ferez en sorte qu'aucune valeur assignée aux arguments de vos ressources ne soit écrite en dur dans le code,
à l'exception du cidr_block définissant la route par défaut de la route_table.

## Steps

### Resources Creation

1. **Provider** :

```terraform

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  default_tags {
    tags = local.default_tags
  }
}

provider "cloudinit" {
  # Configuration options
}
```

2. **VPC** :

```terraform

# Stands for Virtual Private Cloud, it creates an isolated
# network within AWS. The specified CIDR block specifies the range of IP
# addresses than can exist within the VPC. this private network allows
# control over the security, the access and the organisation of the VPC's
# resources

resource "aws_vpc" "main" {
cidr_block = "10.1.0.0/16"
}
```

3. **internet gateway**

```terraform
 # This gateway provides internet access to the
# ressource within the VPC.Once the gateway is linked to the VPC it allows
# the instances that populates the VPC to connect to the internet

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}
```

4. **subnets**

```terraform
# Divides the VPC address range into smaller subnetworks. Here we
# distributed the subnets on two different availability zone which is
# a good practice for high availability

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "${var.region}a"
}


resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone ="${var.region}b"
}
```

5. **route table** :

```terraform
# Defines a set of rules that tells the VPC where to
# direct network traffic. Each rule corresponds to a route which is a
# destination (ip adress range) to a target (here the internet gateway).

resource "aws_route_table" "route_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}
```

**route table asociation**

```terraform
# Allows our subnet to be associated with our route table.
# It ensures that the traffic from instances within the associated subnet
# will follow the routes defined in the route table

resource "aws_route_table_association" "table_association_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_a.id
}
resource "aws_route_table_association" "table_association_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_a.id
}
```

**instances**

```terraform
# Creates a EC2 instance to host the web server

resource "aws_instance" "web1" {
instance_type = var.webserver
ami = var.ami
subnet_id = aws_subnet.subnet_a.id
associate_public_ip_address = true
key_name = var.key
vpc_security_group_ids = [aws_security_group.webserver_allow_http.id, aws_security_group.webserver_allow_ssh.id]
user_data = data.cloudinit_config.webservers.rendered
}

# Security groups control incoming (ingress) and outgoing (egress) access. Each security group specifies certain types of traffic.
# Below is an example configuration for HTTP, HTTPS, and SSH traffic.

# TLS security rules allow HTTPS connections on port 443

resource "aws_security_group" "webserver_allow_tls" {
name = "webserver allow_tls"
description = "Allow TLS inbound traffic and all outbound traffic"
vpc_id = aws_vpc.main.id

tags = {
Name = "webserver allow_tls"
}
}

resource "aws_vpc_security_group_ingress_rule" "webserver_allow_tls_ipv4" {
security_group_id = aws_security_group.webserver_allow_tls.id
cidr_ipv4 = "0.0.0.0/0"
from_port = 443
ip_protocol = "tcp"
to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "webserver_allow_tls_traffic_ipv4" {
security_group_id = aws_security_group.webserver_allow_tls.id
cidr_ipv4 = "0.0.0.0/0"
ip_protocol = "-1"
}

# http security rules allow HTTPS connections on and from port 80

resource "aws_security_group" "webserver_allow_http" {
name = "webserver allow_http"
description = "Allow http inbound traffic and all outbound traffic"
vpc_id = aws_vpc.main.id

tags = {
Name = "webserver allow_http"
}
}

resource "aws_vpc_security_group_ingress_rule" "webserver_allow_http_ipv4" {
security_group_id = aws_security_group.webserver_allow_http.id
cidr_ipv4 = "0.0.0.0/0"
from_port = 80
ip_protocol = "tcp"
to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "webserver_allow_http_all_traffic_ipv4" {
security_group_id = aws_security_group.webserver_allow_http.id
cidr_ipv4 = "0.0.0.0/0"
ip_protocol = "-1"
}

# ssh security rules allow ssh connections on and from port 22

resource "aws_security_group" "webserver_allow_ssh" {
name = "webserver allow_ssh"
description = "Allow http inbound traffic and all outbound traffic"
vpc_id = aws_vpc.main.id

tags = {
Name = "webserver allow_ssh"
}
}

resource "aws_vpc_security_group_ingress_rule" "webserver_allow_ssh_ipv4" {
security_group_id = aws_security_group.webserver_allow_ssh.id
cidr_ipv4 = "0.0.0.0/0"
from_port = 80
ip_protocol = "tcp"
to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "webserver_allow_ssh_all_traffic_ipv4" {
security_group_id = aws_security_group.webserver_allow_ssh.id
cidr_ipv4 = "0.0.0.0/0"
ip_protocol = "-1"
}
```

**Cloud-init**

```terraform
# Cloud-Init is a tool that allows you to initialize cloud instances with custom scripts and configuration files at startup.
# Here, it installs necessary packages, retrieves a web template, and starts the web server. This automation ensures that our server is ready with the
# required setup as soon as it launches.

data "cloudinit_config" "webservers" {
gzip = false
base64_encode = false

part {
filename = "cloud-config.yml"
content_type = "text/cloud-config"

    content = file("${path.module}/files/cloud-config.yml")

}
}


# output values are used to print configuration information in the cli output after running terraform apply.

output "web1_public_IP" {
value = aws_instance.web1.public_ip
}
```

**cloudinit_config**

```terraform
resource "cloudinit_config" "foobar" {
gzip = false
base64_encode = false


part {
filename = "cloud-config.yml"
content_type = "text/cloud-config"

    content = file("${path.module}/files/cloud-config.yml")

}
}
```

**cloud-config-yml**

```yaml
#cloud-config
package_update: true
packages:
  - wget
  - unzip
  - nginx

runcmd:
  - cd /var/run
  - wget -O template.zip  https://html5up.net/forty/download
  - unzip /var/run/template.zip -d /var/www/html/
```

**input variable**

```terraform
# Input variables can be used in all the module but are different from local
# Input variables can be defined outside the module and specified during the Terraform run.
# We can define them with a default value or as required, making the code adaptable to different environments without hardcoding values.

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "webserver" {
  type        = string
  description = "Type d'instance"
  default     = "t3.small"
}

variable "ami" {
  type        = string
  default     = "ami-0866a3c8686eaeeba"
  description = " AMI de l'instance"
}
variable "key" {
  type        = string
  default     = "vockey"
  description = "clef SSH"
}
```

**locals**

```terraform
# locals are variables that allow us to have centralized reusable values.
# Unlike input variables, locals are limited to their own module and cannot be defined or used outside of it.

locals {
  owner = "ic"
  tp    = "terraform-aws-vpc-dynamic"
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }
}

```

## Results

**terraform apply**

![terraform-apply-1](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-1.png?raw=true)

![terraform-apply-2](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-2.png?raw=true)

![terraform-apply-3](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-3.png?raw=true)

![terraform-apply-4](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/terraform-apply-4.png)
![terraform-apply-5](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-5.png?raw=true)

![terraform-apply-6](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-6.png?raw=true)

![terraform-apply-7](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-7.png?raw=true)

![terraform-apply-8](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-8.png?raw=true)

![terraform-apply-9](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-apply-output-9.png?raw=true)

**terraform show**

![terraform-show-vpc](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-show-vpc.png?raw=true)

![terraform-show-web-instance](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-terraform-show-web-instance.png?raw=true)

**AWS console**

![AWS-console-instances](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-AWS-console-EC2-instance.png?raw=true)

![AWS-console-VPC](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-AWS-console-vpc.png?raw=true)

**Web server**

![Web-server](https://github.com/Yonahey/aws-atelier/blob/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web/screenshots/TP2-forty-template.png?raw=true)

## Links

[Github](https://github.com/Yonahey/aws-atelier/tree/TP/2E2-terraform-aws-vpc-web/terraform-aws-vpc-web)
