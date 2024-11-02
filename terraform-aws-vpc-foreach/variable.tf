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


