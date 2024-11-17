# TP3E1-terraform-aws-vpc-count

## Instructions

Dans un nouveau répertoire nommé terraform-aws-vpc-count, créer une configuration terraform qui déploie les mêmes ressources que les TP précédents (TP2E1) en faisant en sorte que le nombre de subnets déployés dépende d'une variable locale nommée subnet_count.

Cette locale aura pour valeur un nombre compris entre 0 et 256.

Chaque subnet :

aura pour cidr_block un /24.
sera déployé sur chaque availability_zone disponible successive.
ajustera son tag Name en y ajoutant -X correspondant au numéro d'instance
Par exemple pour une région contenant 2 AZ (A et B) et subnet_count = 3 :

- 1 VPC ayant pour cidr_block: 10.1.0.0/16.

- 1 Internet Gateway rattachée au vpc.

- 1 Subnet dans l'availability_zone: A ayant pour cidr_block: 10.1.0.0/24 ayant pour tag Name: <user>-<date>-0.

- 1 Subnet dans l'availability_zone: B ayant pour cidr_block: 10.1.1.0/24 ayant pour tag Name: <user>-<date>-1.

- 1 Subnet dans l'availability_zone: A ayant pour cidr_block: 10.1.2.0/24 ayant pour tag Name: <user>-<date>-2.

- 1 Route Table ayant comme route 0.0.0.0/0 l'internet gateway.

- 3 Route Table Association pour associer chaque subnet à la route table.

Note: La région utilisée dans le lab est us-east-1.

### Resource Modification

**locals**

```terraform
# Here, we declare the `local` subnet-count to use its value later in order to loop over subnet creation

locals {
  owner        = "ic"
  tp           = "terraform-aws-vpc-dynamic"
  subnet_count = "3"
}

locals {
  default_tags = {
    Owner = local.owner
    TP    = local.tp
  }
}

```

**subnets**

```terraform
# Divides the VPC address range into smaller subnetworks.
# Here we used the `count` meta-argument which allows us to create multiple instances of a resource.
# `count.index` refers to the index of the resource isntance and is used to dynamically differenciates resource names and loop over availability zones.

resource "aws_subnet" "subnets" {
  count  = local.subnet_count
  vpc_id = aws_vpc.main.id
  cidr_block        = cidrsubnet("10.1.0.0/16", 8, count.index)
  availability_zone = data.aws_availability_zones.current.names[count.index]

   tags = {
    Name = format("%s-%s-%d", local.name, local.current_date, count.index)
  }
}


```

**route table asociation**

```terraform
# Allows our subnet to be associated with our route table.
# The `count` meta argument is used to create as many association as subnets
# As we use `count` with the same value when creating subnets and route table association resources
# # The `count` value is synchronized across the two resources, allowing us to associate each route table association with its corresponding subnet using `count.index`.


resource "aws_route_table_association" "table_association_a" {
  count          = local.subnet_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_a.id
}
```

## Results

**terraform plan**

!["terraform-plan-1"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-1.png?raw=true)
!["terraform-plan-2"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-2.png?raw=true)
!["terraform-plan-3"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-3.png?raw=true)
!["terraform-plan-4"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-4.png?raw=true)
!["terraform-plan-5"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-5.png?raw=true)
!["terraform-plan-6"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-6.png?raw=true)
!["terraform-plan-7"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-7.png?raw=true)
!["terraform-plan-8"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-8.png?raw=true)
!["terraform-plan-9"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-plan-9.png?raw=true)

**terraform apply**

!["terraform-apply-1"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/terraform-apply-1.png?raw=true)

**AWS console**

!["aws-console-1"](https://github.com/Yonahey/aws-atelier/blob/TP/3E1-count/terraform-aws-vpc-count/screenshots/aws-console-1.png?raw=true)
