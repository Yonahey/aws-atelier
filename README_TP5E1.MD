# TPE5E1-terraform-aws-ec2-module

## Instructions

Créer un module stocké localement dans un répertoire terraform-aws-ec2-module qui déploie une instance EC2 paramétrée comme ceci :
instance_type → "t3.micro ou t2.micro".
ami → la plus récente ayant pour nom ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-\*. (noble numbat)
subnet_id → paramétrable par variable.
Les inputs (variables) du module seront :

subnet_id : de type string qui permettra de configurer le paramètre du même nom de l'instance. Cette variable sera obligatoire.
Les retours (outputs) du module seront :

id: l'ID de l'instance EC2
ip: l'adresse IP privée assignée à l'instance.
Pour tester, appeler le module dans le répertoire terraform-aws-vpc-registry :

- Créer un fichier ec2.tf et faire appel au module terraform-aws-ec2-module.
- Créer un fichier outputs.tf et afficher sur la sortie standard les informations suivantes :
  - l'output vpc_id
  - l'output subnets
  - l'id de l'instance déployée par le module terraform-aws-ec2-module.
  - l'ip de l'instance déployée par le module terraform-aws-ec2-module.

Fournir un document avec configuration et captures écran (console AWS, plan, apply.. etc...)

### Module EC2 Ressources

**main.tf**

```terraform
# In our module main.tf we chose the type of machine we want to push in our infrastructure
resource "aws_instance" "EC2" {
  instance_type = "t3.micro"
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = var.subnet_id
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
```

**output.tf**

```terraform
# the outputs are the values available when calling the module. Here we make the EC2 id , private IP and DNS available
output "instance_id" {
  description = "ID de l'instance"
  value       = aws_instance.EC2.id
}

output "instance_private_ip" {
  description = "IP privée de l'instance"

  value = aws_instance.EC2.private_ip
}

output "instance_private_dns" {
  description = "DNS privé de l'instance"

  value = aws_instance.EC2.private_dns
}
```

### Calling the EC2 module

In an other module or project we can import the EC2 module we created above by providing it's path :

```terraform
module "ec2" {
  source    = "../terraform-aws-ec2-module"
  subnet_id = aws_subnet.main.id
}
```

When defining the outputs we can use the child module (EC2) outputs

```terraform
output "ec2module_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_module_instance_private_ip" {
  value = module.ec2.instance_private_ip
}

output "ec2_module_instance_private_dns" {
  value = module.ec2.instance_private_dns
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {

  value = aws_subnet.main.id

}
```

## Results

**terraform plan**

**terraform apply**
!["terraform-apply-1"](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/terraform-apply-1.png?raw=true)
!["terraform-apply-2"](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/terraform-apply-2.png?raw=true)
!["terraform-apply-3"](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/terraform-apply-3.png?raw=true)
!["terraform-apply-4"](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/terraform-apply-4.png?raw=true)
!["terraform-apply-5"](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/terraform-apply-5.png?raw=true)
!["terraform-output](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/terraform-apply-outputs.png?raw=true)

**AWS console**
!["aws-console-1"](https://github.com/Yonahey/aws-atelier/blob/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry/screenshots/AWS-console.png?raw=true)

**Links**
["Github"](https://github.com/Yonahey/aws-atelier/tree/TP/5E1-terraform-aws-ec2-module/terraform-aws-vpc-registry)
