# TP3E2-terraform-aws-vpc-for_each

## Instructions

Dans un nouveau répertoire nommé terraform-aws-vpc-foreach, créer une configuration terraform qui déploie les mêmes ressources que les TP précédents en faisant en sorte que le nombre de subnets déployés dépende d'une variable locale nommée subnets.

Cette variable locale sera de type map et aura pour clé un bloc CIDR et en valeur, le nom d'une zone de disponibilité.

On utilisera la zone de disponibilité dans le tag Name des subnets.

Par exemple avec la local subnets précédente :

- 1 VPC ayant pour cidr_block: 10.1.0.0/16.
- 1 Internet Gateway rattachée au vpc.
- 1 Subnet dans l'availability_zone: A ayant pour cidr_block: 10.1.0.0/24 ayant pour tag Name: <user>-<date>-eu-north-1a.
- 1 Subnet dans l'availability_zone: B ayant pour cidr_block: 10.1.1.0/24 ayant pour tag Name: <user>-<date>-eu-north-1b.
- 1 Subnet dans l'availability_zone: C ayant pour cidr_block: 10.1.2.0/24 ayant pour tag Name: <user>-<date>-eu-north-1c.
- 1 Route Table ayant comme route 0.0.0.0/0 l'internet gateway.
- 3 Route Table Association pour associer chaque subnet à la route table.

Note: La région utilisée dans le lab est us-east-1.

Fournir un document avec configuration et captures écran (console AWS, plan, apply.. etc...)

### Resource Modification

**locals**

````terraform
# Here, we declare the `local` subnets. The variable is bound to a map so we can use its key and value to create our subnets dynamically.

locals {
  vpc_cidr = "10.1.0.0/16"
  owner    = "ic"
  tp       = "terraform-aws-vpc-for_each"
  subnets = {
    "10.1.0.0/24" = "us-east-1a"
    "10.1.1.0/24" = "us-east-1b"
    "10.1.2.0/24" = "us-east-1c"
  }
  region = "us-east-1"
  date   = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }

}

**subnets**

```terraform
# Divides the VPC address range into smaller subnetworks.
# Here we used the `for_each` meta-argument, which allows us to create multiple instances of a resource dynamically based on a map.
# `for_each` iterates over the `local.subnets` map, where:
# - `each.key` refers to the map's key (CIDR block of the subnet).
# - `each.value` refers to the map's value (availability zone).

resource "aws_subnet" "subnets" {
  for_each          = local.subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = each.value


  tags = {
    Name = join("-", [local.owner, local.date, "${each.value}"])
  }
}



````

**route table asociation**

```terraform
# Allows each subnet to be associated with the route table.
# The `for_each` meta-argument is used to create as many route table associations as there are subnets.
# Since `for_each` is used with the same key-value pairs as the subnets resource, the two resources are synchronized.
# `each.key` refers to the CIDR block of the subnet, while `each.value` provides the full subnet resource, including its ID.

resource "aws_route_table_association" "main" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main.id
}
```

## Results

**terraform plan**

!["terraform-plan-1"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-1.png?raw=true)
!["terraform-plan-2"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-2.png?raw=true)
!["terraform-plan-3"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-3.png?raw=true)
!["terraform-plan-4"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-4.png?raw=true)
!["terraform-plan-5"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-5.png?raw=true)
!["terraform-plan-6"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-6.png?raw=true)
!["terraform-plan-7"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-7.png?raw=true)
!["terraform-plan-8"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-plan-8.png?raw=true)
**terraform apply**

!["terraform-apply-1"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/terraform-apply-1.png?raw=true)

**AWS console**

!["aws-console-1"](https://github.com/Yonahey/aws-atelier/blob/feat/TP-3E2-for_each/terraform-aws-vpc-foreach/screenshots/aws-console-1.png?raw=true)

**Links**

[Github](https://github.com/Yonahey/aws-atelier/tree/feat/TP-3E2-for_each/terraform-aws-vpc-foreach)
