variable "subnet_id" {
  description = "ID du sous-reseau"
  type        = string
}

variable "instance_count" {
  description = "nombre d'instance EC2 à déployer"
  type = number
  default = 1
}

variable "instance_name_tag" {
  description = "prefixe du tag name des instances EC2"
  type= string
}