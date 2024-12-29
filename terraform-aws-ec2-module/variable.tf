variable "subnets" {
  description = "ID du sous-reseau"
  type        = map(string)
}

variable "instance_name_tag" {
  description = "prefixe du tag name des instances EC2"
  type= string
}