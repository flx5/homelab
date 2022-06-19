variable "traefik_network" {
  type        = string
}

variable "fqdn" {
  type        = string
}

variable "devices" {
  type        = list(string)
  default = []
}