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

variable "docker_ip" {
  type = string
}

variable "networks" {
  type = object({
    admin_network = object({
      id = string
      domain = string
    })
    internet_network = object({
      id = string
      domain = string
    })
  })
}