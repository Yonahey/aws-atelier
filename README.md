# TP1E1-terraform-aws-vpc

## Instructions

Dans un nouveau répertoire nommé terraform-aws-vpc, créer un configuration terraform qui déploie les ressources suivantes dans la région us-east-1

- 1 VPC ayant pour cidr_block: 10.1.0.0/16.
- 1 Internet Gateway rattachée au vpc.
- 1 Subnet dans l'availability_zone_A ayant pour cidr_block: 10.1.0.0/24.
- 1 Subnet dans l'availability_zone_B ayant pour cidr_block: 10.1.1.0/24.
- 1 Route Table ayant comme route 0.0.0.0/0 l'internet gateway.
- 2 Route Table Association pour associer chaque subnet à la route table.

## Steps

### Resource Creation

1. **provider** :

```terraform
# The provider configuration allows terraform to interact with AWS ressources.
# It also specify the region where the ressources will be created.
# Here we also added default tags that will be created for all of our ressources

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
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
```

2. **vpc** :

```terraform

# Stands for Virtual Private Cloud, it creates an isolated
# network within AWS. The specified CIDR block specifies the range of IP
# addresses than can exist within the VPC. this private network allows
# control over the security, the access and the organisation of the VPC's
# ressources

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
  availability_zone = "us-east-1a"
}


resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1b"
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
# It ensures that tyhe traffic from instances within the associated subnet
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

**locals**

```terraform
# locals are variable,they allow us to have centralized reusable values bound to them.
# thoses variables can't be defined pur used ouside of their module

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

**terraform plan**

hese screenshots show the Terraform plan, verifying that the configuration is valid and showing the changes that Terraform will make

![terraform-plan-1](https://github.com/Yonahey/aws-atelier/blob/TP/1E1-terraform-aws-vpc/terraform-aws-vpc/screenshots/terraform-plan-1.png?raw=true)

![terraform-plan-2](https://github.com/Yonahey/aws-atelier/blob/TP/1E1-terraform-aws-vpc/terraform-aws-vpc/screenshots/terraform-plan-2.png?raw=true)

![terraform-plan-3](https://github.com/Yonahey/aws-atelier/blob/TP/1E1-terraform-aws-vpc/terraform-aws-vpc/screenshots/terraform-plan-3.png?raw=true)

**AWS console**
![aws-console](https://github.com/Yonahey/aws-atelier/blob/TP/1E1-terraform-aws-vpc/terraform-aws-vpc/screenshots/aws-console.png?raw=true)

## Links

[Github](https://github.com/Yonahey/aws-atelier/blob/TP/1E1-terraform-aws-vpc/terraform-aws-vpc)
[AWS-documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
