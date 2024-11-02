variable "subnet_id" {
  description = "ID du sous-reseau"
  type        = string
}

variable "number"{
    type = number
    description = "nombre d'instance a déployer"
    default = 1
}
variable "name"{
    type = string
    description = "name tag de l'instance"
}