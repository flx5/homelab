variable "traefik_network" {
  type        = string
}

variable "fqdn" {
  type = string
}

variable "name" {
  type = string
  default = "nginx"
}

variable "service_name" {
  type = string
  default = "nginx"
}

variable "files" {
  type = list(object({
    filename = string
    content = string
  }))

 # default = {}
}