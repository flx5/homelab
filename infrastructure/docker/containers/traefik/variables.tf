variable "internal_network_name" {
  type        = string
}

variable "wan_network_name" {
  type        = string
}

variable "configurations" {
  type = map(string)
}

variable "additional_entrypoints" {
  type = map(number)
}

variable "hostname" {
  type = string
  default = "traefik"
}

variable "acme_email" {
  type = string
  default = ""
}

variable "error_host" {
  type = string
}