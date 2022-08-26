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

variable "recordings_path" {
  type = object({
    path: string
    backup: bool
  })
}

variable "config_path" {
  type = object({
    path: string
    backup: bool
  })
}