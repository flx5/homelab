variable "name" {
  type = string
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

variable "domain" {
  type = string
}

variable "bridge" {
  type = string
}

variable "mac" {
  type = string
}

variable "spice_address" {
  type = string
}

variable "block_devices" {
  type = list(string)
  default = []
}

variable "data_pool_name" {
  type = string
}

variable "mounts" {
  type = list(list(string))

  default = []
}