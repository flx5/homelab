variable "name" {
  type = string
  validation {
    # https://stackoverflow.com/questions/106179/regular-expression-to-match-dns-hostname-or-ip-address
    condition = can(regex("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$", var.name))
    error_message = "Must be valid hostname"
  }
}

variable "memory" {
  type = string
  default = 2048
}

variable "pool_name" {
  type = string
}

variable "ssh_id" {
  type = string
}

variable "base_disk" {
  type = string
}

variable "network" {
  type = string
}