variable "bucket_prefix" {
  type        = string
  description = "Prefix du compartiment"
  default     = "ic-bucket-"
}

variable "owner" {
  type        = string
  description = "Proprietaire du compartiement"
}

variable "index_file" {
  type        = string
  description = "Fichier index"
}
variable "error_file" {
  type        = string
  description = "Fichier erreur 404"
}